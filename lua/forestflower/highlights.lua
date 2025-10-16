local highlights = {}
-- After refactor, generation logic delegated to groups aggregator.
-- This file now focuses on helper utilities and the public API entrypoint for highlight generation.

local util = require("forestflower.util")

---@enum Styles
local styles = {
  bold = "bold",
  italic = "italic",
  reverse = "reverse",
  undercurl = "undercurl",
  underline = "underline",
  standout = "standout",
  strikethrough = "strikethrough",
  nocombine = "nocombine",
}

---@alias Highlight vim.api.keyset.highlight

---@alias Highlights table<string,Highlight>

---Generates a table that can be accepted by nvim_set_hl
---@param fg string
---@param bg string
---@param stylings? Styles[]
---@param sp? string
---@return { fg: string, bg: string, [Styles]: boolean?, sp: string? }
local function syntax_entry(fg, bg, stylings, sp)
  ---@type { fg: string, bg: string, [Styles]: boolean?, sp: string? }
  local highlight = { fg = fg, bg = bg }

  if stylings then
    for _, style in ipairs(stylings) do
      highlight[style] = true
    end
  end

  if sp then
    highlight["sp"] = sp
  end

  return highlight
end

---Generates the various highlight groups for this colour scheme to be used by Neovim.
---@param theme ForestflowerTheme
---@param options Config
---@return Highlights
highlights.generate_syntax = function(theme, options)
  -- Refactored: delegate to groups aggregator modules.
  local groups_builder = require("forestflower.groups")
  local syntax = groups_builder.build(theme, options)
  local palette = theme.palette
  local util = require("forestflower.util")

  -- Additional legacy groups below retained for backward compatibility; consider migrating
  -- them into modules (treesitter/languages/legacy) in a future cleanup pass.

  -- Remove local palette/ui/syn/status unpack used by old monolith (handled inside modules)
  local ui = theme.ui
  -- Comments are italic by default
  local comment_italics = options.disable_italic_comments and {} or { styles.italic }
  -- All other italics are disabled by default
  local optional_italics = options.italics and { styles.italic } or {}

  ---This respects the transparency settings of the user.
  ---@param colour_to_set string The intended background if transparency is disabled
  ---@return string
  local function transparency_respecting_colour(colour_to_set)
    if options.transparent_background_level > 0 then
      return palette.none
    else
      return colour_to_set
    end
  end

  ---Set the background colour for the signs column.
  ---This isn't an easy logic pairing to use composition for, so we just roll a
  ---specific function for it to make inline code easier.
  ---
  ---@param colour_to_set string The intended colour if the sign column background is grey
  ---@return string
  local function set_signs_background_colour(colour_to_set)
    if options.transparent_background_level > 0 or options.sign_column_background == "none" then
      return palette.none
    else
      return colour_to_set
    end
  end

  ---Sets the colour, respecting the `sign_column_background` settings of the user.
  ---If the `sign_column_background` is `"none"`, then it'll return `palette.none`, otherwise
  ---whichever colour was passed in.
  ---@param colour_to_set string
  ---@return string
  local function sign_column_respecting_colour(colour_to_set)
    if options.sign_column_background == "none" then
      return palette.none
    else
      return colour_to_set
    end
  end

  local function set_colour_based_on_ui_contrast(low_contrast_colour, other_colour)
    if options.ui_contrast == "low" then
      return low_contrast_colour
    else
      return other_colour
    end
  end

  ---@type Highlights
  -- NOTE: Most direct palette.* references have been migrated to role-based theme tables (ui.*, syntax.*)
  -- Remaining raw palette usages below are intentional for:
  --   1. Generic passthrough colour groups (Red/Green/Yellow/etc.) kept for ecosystem compatibility
  --   2. Rainbow / delimiter / decorative multi-hue groups where semantic role does not apply
  --   3. Plugin specific brand accents that deliberately want a precise palette token
  local syntax = {
    ColorColumn = syntax_entry(palette.none, ui.surface_variant),
    Conceal = syntax_entry(set_colour_based_on_ui_contrast(ui.outline_variant or ui.outline, ui.outline), palette.none),
    CurSearch = { link = "IncSearch" },
    Cursor = syntax_entry(palette.none, palette.none, { styles.reverse }),
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    CursorColumn = syntax_entry(palette.none, ui.surface),
    CursorLine = syntax_entry(palette.none, ui.surface_variant),
    Directory = syntax_entry(ui.success, palette.none),
    DiffAdd = syntax_entry(palette.none, status.success_container),
    DiffChange = syntax_entry(palette.none, status.info_container),
    DiffDelete = syntax_entry(palette.none, status.error_container),
    DiffText = syntax_entry(ui.background, ui.primary),
    EndOfBuffer = syntax_entry((options.show_eob and ui.surface_variant) or ui.background, palette.none),
    TermCursor = { link = "Cursor" },
    TermCursorNC = { link = "Cursor" },
    ErrorMsg = syntax_entry(status.error, palette.none, { styles.bold, styles.underline }),
    WinSeparator = { link = "VertSplit" },
    Folded = syntax_entry(ui.on_surface_variant, transparency_respecting_colour(ui.surface)),
    FoldColumn = syntax_entry(
      (options.sign_column_background == "grey" and ui.on_surface_variant) or ui.outline,
      sign_column_respecting_colour(ui.surface)
    ),
    SignColumn = syntax_entry(ui.on_surface, sign_column_respecting_colour(ui.surface)),
    IncSearch = syntax_entry(ui.background, ui.primary),
    Substitute = syntax_entry(ui.background, status.warning),
    LineNr = syntax_entry(set_colour_based_on_ui_contrast(ui.on_surface_variant, ui.outline), palette.none),
    LineNrAbove = syntax_entry(set_colour_based_on_ui_contrast(ui.on_surface_variant, ui.outline), palette.none),
    LineNrBelow = syntax_entry(set_colour_based_on_ui_contrast(ui.on_surface_variant, ui.outline), palette.none),
    CursorLineNr = syntax_entry(ui.primary, palette.none, { styles.bold }),
    MatchParen = syntax_entry(palette.none, ui.surface_variant),
    ModeMsg = syntax_entry(ui.fg, palette.none, { styles.bold }),
    MoreMsg = syntax_entry(status.warning, palette.none, { styles.bold }),
    NonText = syntax_entry(ui.surface_variant, palette.none),
    Normal = syntax_entry(ui.fg, transparency_respecting_colour(ui.background)), -- role: base editor foreground/background
    NormalFloat = syntax_entry(
      ui.fg,
      (options.float_style == "bright" and ui.float_background) or ui.float_background_dim
    ),
    FloatBorder = syntax_entry(
      ui.float_border,
      (options.float_style == "bright" and ui.float_background) or ui.float_background_dim
    ),
    FloatTitle = syntax_entry(
      ui.float_title,
      (options.float_style == "bright" and ui.float_background) or ui.float_background_dim,
      { styles.bold }
    ),
    NormalNC = syntax_entry(
      ui.fg,
      transparency_respecting_colour((options.dim_inactive_windows and ui.surface) or ui.background)
    ),
    Pmenu = syntax_entry(ui.fg, ui.popup_background),
    PmenuSbar = syntax_entry(palette.none, ui.popup_background),
    PmenuSel = syntax_entry(ui.background, ui.selection),
    PmenuThumb = syntax_entry(palette.none, ui.scrollbar_thumb),
    Question = syntax_entry(status.warning, palette.none),
    QuickFixLine = syntax_entry(status.tertiary, palette.none, { styles.bold }),
    Search = syntax_entry(ui.background, ui.primary), -- role: primary interactive highlight
    SpecialKey = syntax_entry(status.warning, palette.none),
    SpellBad = syntax_entry(
      options.spell_foreground and status.error or palette.none,
      palette.none,
      { styles.undercurl },
      status.error
    ),
    SpellCap = syntax_entry(
      options.spell_foreground and status.info or palette.none,
      palette.none,
      { styles.undercurl },
      status.info
    ),
    SpellLocal = syntax_entry(
      options.spell_foreground and status.secondary or palette.none,
      palette.none,
      { styles.undercurl },
      status.secondary
    ),
    SpellRare = syntax_entry(
      options.spell_foreground and status.tertiary or palette.none,
      palette.none,
      { styles.undercurl },
      status.tertiary
    ),
    StatusLine = syntax_entry(
      ui.statusline_fg,
      options.transparent_background_level == 2 and palette.none or ui.statusline_bg
    ),
    StatusLineNC = syntax_entry(
      options.transparent_background_level == 2 and ui.statusline_nc_fg_alt or ui.statusline_nc_fg,
      options.transparent_background_level == 2 and palette.none or ui.statusline_nc_bg
    ),
    TabLine = syntax_entry(ui.tab_inactive_fg, ui.tab_inactive_bg),
    TabLineFill = syntax_entry(
      ui.tab_fill_fg,
      options.transparent_background_level == 2 and palette.none or ui.tab_fill_bg
    ),
    TabLineSel = syntax_entry(ui.background, ui.tab_active_bg),
    Title = syntax_entry(palette.warning, palette.none, { styles.bold }),
    -- Use dedicated selection colour; inherit foreground for syntax retention
    Visual = syntax_entry(palette.none, ui.selection),
    -- Non-owning selection variant
    VisualNOS = syntax_entry(palette.none, ui.selection),
    WarningMsg = syntax_entry(status.warning, palette.none, { styles.bold }),
    Whitespace = syntax_entry(ui.surface_variant, palette.none),
    WildMenu = { link = "PmenuSel" },
    WinBar = syntax_entry(
      ui.on_surface_variant,
      options.transparent_background_level == 2 and palette.none or ui.surface,
      { styles.bold }
    ),
    WinBarNC = syntax_entry(
      options.transparent_background_level == 2 and ui.outline or ui.on_surface_variant,
      options.transparent_background_level == 2 and palette.none or ui.surface_variant
    ),
    Terminal = syntax_entry(ui.fg, transparency_respecting_colour(ui.background)),
    ToolbarLine = syntax_entry(ui.fg, transparency_respecting_colour(ui.surface)),

    StatusLineTerm = syntax_entry(
      ui.on_surface_variant,
      options.transparent_background_level == 2 and palette.none or ui.surface_variant
    ),
    StatusLineTermNC = syntax_entry(
      options.transparent_background_level == 2 and ui.outline or ui.on_surface_variant,
      options.transparent_background_level == 2 and palette.none or ui.background
    ),
    VertSplit = syntax_entry(ui.surface_variant, (options.dim_inactive_windows and ui.surface) or palette.none),

    Debug = syntax_entry(ui.primary, palette.none),
    debugPC = syntax_entry(ui.background, status.success),
    debugBreakpoint = syntax_entry(ui.background, status.error),
    ToolbarButton = syntax_entry(ui.background, status.success),
    DiagnosticFloatingError = { link = "ErrorFloat" },
    DiagnosticFloatingWarn = { link = "WarningFloat" },
    DiagnosticFloatingInfo = { link = "InfoFloat" },
    DiagnosticFloatingHint = { link = "HintFloat" },
    DiagnosticError = syntax_entry(
      status.error,
      options.diagnostic_text_highlight and status.error_container or palette.none
    ),
    DiagnosticWarn = syntax_entry(
      status.warning,
      options.diagnostic_text_highlight and status.warning_container or palette.none
    ),
    DiagnosticInfo = syntax_entry(
      status.info,
      options.diagnostic_text_highlight and status.info_container or palette.none
    ),
    DiagnosticHint = syntax_entry(
      status.hint,
      options.diagnostic_text_highlight and status.hint_container or palette.none
    ),
    DiagnosticUnnecessary = syntax_entry(palette.on_surface_variant, palette.none),
    DiagnosticVirtualTextError = { link = "VirtualTextError" },
    DiagnosticVirtualTextWarn = { link = "VirtualTextWarning" },
    DiagnosticVirtualTextInfo = { link = "VirtualTextInfo" },
    DiagnosticVirtualTextHint = { link = "VirtualTextHint" },
    DiagnosticUnderlineError = syntax_entry(
      status.error,
      options.diagnostic_text_highlight and status.error_container or palette.none,
      { styles.undercurl },
      status.error
    ),
    DiagnosticUnderlineWarn = syntax_entry(
      status.warning,
      options.diagnostic_text_highlight and status.warning_container or palette.none,
      { styles.undercurl },
      status.warning
    ),
    DiagnosticUnderlineInfo = syntax_entry(
      status.info,
      options.diagnostic_text_highlight and status.info_container or palette.none,
      { styles.undercurl },
      status.info
    ),
    DiagnosticUnderlineHint = syntax_entry(
      status.success,
      options.diagnostic_text_highlight and status.success_container or palette.none,
      { styles.undercurl },
      status.success
    ),
    DiagnosticSignError = { link = "RedSign" },
    DiagnosticSignWarn = { link = "YellowSign" },
    DiagnosticSignInfo = { link = "BlueSign" },
    DiagnosticSignHint = { link = "GreenSign" },

    -- LSP colours
    LspInlayHint = { link = "InlayHints" },
    LspReferenceText = { link = "CurrentWord" },
    LspReferenceRead = { link = "CurrentWord" },
    LspReferenceWrite = { link = "CurrentWord" },
    LspCodeLens = { link = "VirtualTextInfo" },
    LspCodeLensSeparator = { link = "VirtualTextHint" },
    LspSignatureActiveParameter = { link = "Search" },
    healthError = { link = "Red" },
    healthSuccess = { link = "Green" },
    healthWarning = { link = "Yellow" },

    Boolean = syntax_entry(syn.boolean, palette.none),
    Number = syntax_entry(syn.number, palette.none),
    Float = syntax_entry(syn.number, palette.none),

    PreProc = syntax_entry(syn.keyword, palette.none, optional_italics),
    PreCondit = syntax_entry(syn.keyword, palette.none, optional_italics),
    Include = syntax_entry(syn.keyword, palette.none, optional_italics),
    Define = syntax_entry(syn.keyword, palette.none, optional_italics),
    Conditional = syntax_entry(syn.keyword, palette.none, optional_italics),
    Repeat = syntax_entry(syn.keyword, palette.none, optional_italics),
    Keyword = syntax_entry(syn.keyword, palette.none, optional_italics),
    Typedef = syntax_entry(syn.type, palette.none, optional_italics),
    Exception = syntax_entry(syn.keyword, palette.none, optional_italics),
    Statement = syntax_entry(syn.keyword, palette.none, optional_italics),

    Error = syntax_entry(syn.error, palette.none),
    StorageClass = syntax_entry(syn.type, palette.none),
    Tag = syntax_entry(syn.type, palette.none),
    Label = syntax_entry(syn.type, palette.none),
    Structure = syntax_entry(syn.type, palette.none),
    Operator = syntax_entry(syn.operator, palette.none),
    Special = syntax_entry(syn.special, palette.none),
    SpecialChar = syntax_entry(syn.special, palette.none),
    Type = syntax_entry(syn.type, palette.none),
    Function = syntax_entry(syn["function"], palette.none),
    String = syntax_entry(syn.string, palette.none),
    Character = syntax_entry(syn.string, palette.none),
    Constant = syntax_entry(syn.constant, palette.none),
    Macro = syntax_entry(syn.macro, palette.none),
    Identifier = syntax_entry(ui.fg, palette.none),
    Variable = syntax_entry(syn.variable, palette.none),

    Comment = syntax_entry(syn.comment, palette.none, comment_italics),
    SpecialComment = syntax_entry(syn.comment, palette.none, comment_italics),
    Todo = syntax_entry(syn.todo, palette.none, { styles.bold }),

    Delimiter = syntax_entry(syn.punctuation, palette.none),
    Ignore = syntax_entry(syn.comment, palette.none),
    Underlined = syntax_entry(palette.none, palette.none, { styles.underline }),

    Fg = syntax_entry(palette.on_surface, palette.none),
    Grey = syntax_entry(palette.success, palette.none),
    Red = syntax_entry(palette.error, palette.none),
    Orange = syntax_entry(palette.warning, palette.none),
    Yellow = syntax_entry(palette.warning, palette.none),
    Green = syntax_entry(palette.success, palette.none),
    Aqua = syntax_entry(palette.secondary, palette.none),
    Blue = syntax_entry(palette.info, palette.none),
    Purple = syntax_entry(palette.tertiary, palette.none),

    RedItalic = syntax_entry(palette.error, palette.none, optional_italics),
    OrangeItalic = syntax_entry(palette.warning, palette.none, optional_italics),
    YellowItalic = syntax_entry(palette.warning, palette.none, optional_italics),
    GreenItalic = syntax_entry(palette.success, palette.none, optional_italics),
    AquaItalic = syntax_entry(palette.secondary, palette.none, optional_italics),
    BlueItalic = syntax_entry(palette.info, palette.none, optional_italics),
    PurpleItalic = syntax_entry(palette.tertiary, palette.none, optional_italics),

    RedBold = syntax_entry(palette.error, palette.none, { styles.bold }),
    OrangeBold = syntax_entry(palette.warning, palette.none, { styles.bold }),
    YellowBold = syntax_entry(palette.warning, palette.none, { styles.bold }),
    GreenBold = syntax_entry(palette.success, palette.none, { styles.bold }),
    AquaBold = syntax_entry(palette.secondary, palette.none, { styles.bold }),
    BlueBold = syntax_entry(palette.info, palette.none, { styles.bold }),
    PurpleBold = syntax_entry(palette.tertiary, palette.none, { styles.bold }),

    RedSign = syntax_entry(status.error, set_signs_background_colour(ui.surface_variant)),
    OrangeSign = syntax_entry(ui.primary, set_signs_background_colour(ui.surface_variant)),
    YellowSign = syntax_entry(status.warning, set_signs_background_colour(ui.surface_variant)),
    GreenSign = syntax_entry(status.success, set_signs_background_colour(ui.surface_variant)),
    AquaSign = syntax_entry(status.secondary, set_signs_background_colour(ui.surface_variant)),
    BlueSign = syntax_entry(status.info, set_signs_background_colour(ui.surface_variant)),
    PurpleSign = syntax_entry(status.tertiary, set_signs_background_colour(ui.surface_variant)),

    Added = { link = "Green" },
    Removed = { link = "Red" },
    Changed = { link = "Blue" },

    -- Configuration based on `diagnostic_text_highlight` option
    ErrorText = syntax_entry(
      palette.none,
      options.diagnostic_text_highlight and status.error_container or palette.none,
      { styles.undercurl },
      status.error
    ),
    WarningText = syntax_entry(
      palette.none,
      options.diagnostic_text_highlight and status.warning_container or palette.none,
      { styles.undercurl },
      status.warning
    ),
    InfoText = syntax_entry(
      palette.none,
      options.diagnostic_text_highlight and status.info_container or palette.none,
      { styles.undercurl },
      status.info
    ),
    HintText = syntax_entry(
      palette.none,
      options.diagnostic_text_highlight and status.hint_container or palette.none,
      { styles.undercurl },
      status.hint
    ),

    ErrorLine = options.diagnostic_line_highlight and syntax_entry(palette.none, status.error_container) or {},
    WarningLine = options.diagnostic_line_highlight and syntax_entry(palette.none, status.warning_container) or {},
    InfoLine = options.diagnostic_line_highlight and syntax_entry(palette.none, status.info_container) or {},
    HintLine = options.diagnostic_line_highlight and syntax_entry(palette.none, status.hint_container) or {},

    -- Configuration based on `diagnostic_virtual_text` option
    VirtualTextWarning = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Yellow" },
    VirtualTextError = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Red" },
    VirtualTextInfo = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Blue" },
    VirtualTextHint = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Green" },

    -- Diagnostic text inherits the background of the floating window, which is Neovim's default.
    ErrorFloat = syntax_entry(status.error, palette.none),
    WarningFloat = syntax_entry(status.warning, palette.none),
    InfoFloat = syntax_entry(status.info, palette.none),
    HintFloat = syntax_entry(status.hint, palette.none),
    InlayHints = syntax_entry(syn.comment, palette.none),
    CurrentWord = syntax_entry(palette.none, palette.none, { styles.bold }),

    -- Git commit colours
    gitcommitSummary = { link = "Green" },
    gitcommitUntracked = { link = "Grey" },
    gitcommitDiscarded = { link = "Grey" },
    gitcommitSelected = { link = "Grey" },
    gitcommitUnmerged = { link = "Grey" },
    gitcommitOnBranch = { link = "Grey" },
    gitcommitArrow = { link = "Grey" },
    gitcommitFile = { link = "Green" },

    -- Help colours
    helpNote = syntax_entry(palette.tertiary, palette.none, { styles.bold }),
    helpHeadline = syntax_entry(palette.error, palette.none, { styles.bold }),
    helpHeader = syntax_entry(palette.warning, palette.none, { styles.bold }),
    helpURL = syntax_entry(palette.success, palette.none, { styles.underline }),
    helpHyperTextEntry = syntax_entry(palette.warning, palette.none, { styles.bold }),
    helpHyperTextJump = { link = "Yellow" },
    helpCommand = { link = "Aqua" },
    helpExample = { link = "Green" },
    helpSpecial = { link = "Blue" },
    helpSectionDelim = { link = "Grey" },

    -- Treesitter
    TSStrong = syntax_entry(palette.none, palette.none, { styles.bold }),
    TSEmphasis = syntax_entry(palette.none, palette.none, { styles.italic }),
    TSUnderline = syntax_entry(palette.none, palette.none, { styles.underline }),
    TSStrike = syntax_entry(palette.none, palette.none, { styles.strikethrough }),
    TSNote = syntax_entry(palette.background, palette.success, { styles.bold }),
    TSWarning = syntax_entry(palette.background, palette.warning, { styles.bold }),
    TSDanger = syntax_entry(palette.background, palette.error, { styles.bold }),
    TSAnnotation = { link = "Purple" },
    TSAttribute = { link = "Purple" },
    TSBoolean = { link = "Purple" },
    TSCharacter = { link = "Aqua" },
    TSCharacterSpecial = { link = "SpecialChar" },
    TSComment = { link = "Comment" },
    TSConditional = { link = "Red" },
    TSConstBuiltin = { link = "Constant" },
    TSConstMacro = { link = "PurpleItalic" },
    TSConstant = { link = "Constant" },
    TSConstructor = { link = "Function" },
    TSDebug = { link = "Debug" },
    TSDefine = { link = "Define" },
    TSEnvironment = { link = "Macro" },
    TSEnvironmentName = { link = "Type" },
    TSError = { link = "Error" },
    TSException = { link = "Red" },
    TSField = { link = "Blue" },
    TSFloat = { link = "Purple" },
    TSFuncBuiltin = { link = "Green" },
    TSFuncMacro = { link = "Green" },
    TSFunction = { link = "Function" },
    TSFunctionCall = { link = "Function" },
    TSInclude = { link = "Red" },
    TSKeyword = { link = "RedItalic" },
    TSKeywordFunction = { link = "RedItalic" },
    TSKeywordOperator = { link = "Orange" },
    TSKeywordReturn = { link = "RedItalic" },
    TSLabel = { link = "Orange" },
    TSLiteral = { link = "String" },
    TSMath = { link = "Blue" },
    TSMethod = { link = "Function" },
    TSMethodCall = { link = "Function" },
    TSModuleInfoGood = { link = "Green" },
    TSModuleInfoBad = { link = "Red" },
    TSNamespace = { link = "YellowItalic" },
    TSNone = { link = "Fg" },
    TSNumber = { link = "Purple" },
    TSOperator = { link = "Orange" },
    TSParameter = { link = "Variable" },
    TSParameterReference = { link = "Variable" },
    TSPreProc = { link = "PreProc" },
    TSProperty = { link = "Blue" },
    TSPunctBracket = { link = "Fg" },
    TSPunctDelimiter = { link = "Grey" },
    TSPunctSpecial = { link = "Blue" },
    TSRepeat = { link = "Red" },
    TSStorageClass = { link = "Orange" },
    TSStorageClassLifetime = { link = "Orange" },
    TSString = { link = "String" },
    TSStringEscape = { link = "Green" },
    TSStringRegex = { link = "Green" },
    TSStringSpecial = { link = "SpecialChar" },
    TSSymbol = { link = "Aqua" },
    TSTag = syntax_entry(syn.jsx_component, palette.none),
    TSTagAttribute = syntax_entry(syn.jsx_prop, palette.none),
    TSTagDelimiter = syntax_entry(syn.punctuation, palette.none),
    TSText = { link = "Green" },
    TSTextReference = { link = "Constant" },
    TSTitle = { link = "Title" },
    TSTodo = { link = "Todo" },
    TSType = { link = "Type" },
    TSTypeBuiltin = { link = "Type" },
    TSTypeDefinition = { link = "Type" },
    TSTypeQualifier = { link = "Orange" },
    TSURI = syntax_entry(palette.info, palette.none, { styles.underline }),
    TSVariable = { link = "Variable" },
    TSVariableBuiltin = { link = "Constant" },

    javascriptTSInclude = { link = "Purple" },
    typescriptTSInclude = { link = "Purple" },
    tsxTSConstructor = { link = "TSType" },
    luaTSConstructor = { link = "luaBraces" },
    goTSInclude = { link = "Purple" },
    goTSNamespace = { link = "Fg" },
    goTSConstBuiltin = { link = "AquaItalic" },
    htmlTSText = { link = "TSNone" },
    jsonKeyword = { link = "Green" },
    jsonString = { link = "Fg" },
    jsonQuote = { link = "Grey" },
    jsonTSLabel = { link = "jsonKeyword" },
    jsonTSString = { link = "jsonString" },
    jsonTSStringEscape = { link = "SpecialChar" },
    yamlBlockMappingKey = { link = "Green" },
    yamlString = { link = "Fg" },
    yamlConstant = { link = "OrangeItalic" },
    yamlKeyValueDelimiter = { link = "Grey" },
    yamlTSField = { link = "yamlBlockMappingKey" },
    yamlTSString = { link = "yamlString" },
    yamlTSStringEscape = { link = "SpecialChar" },
    yamlTSBoolean = { link = "yamlConstant" },
    yamlTSConstBuiltin = { link = "yamlConstant" },
    tomlKey = { link = "Green" },
    tomlString = { link = "Fg" },
    tomlTSProperty = { link = "tomlKey" },
    tomlTSString = { link = "tomlString" },

    -- New Treesitter highlights
    ["@annotation"] = { link = "TSAnnotation" },
    ["@attribute"] = { link = "TSAttribute" },
    ["@boolean"] = { link = "TSBoolean" },
    ["@boolean.yaml"] = { link = "yamlTSBoolean" },
    ["@character"] = { link = "TSCharacter" },
    ["@character.special"] = { link = "TSCharacterSpecial" },
    ["@comment"] = { link = "TSComment" },
    ["@comment.error"] = { link = "TSDanger" }, -- Used to be @text.danger
    ["@comment.note"] = { link = "TSNote" },
    ["@comment.todo"] = { link = "TSTodo" },
    ["@comment.warning"] = { link = "TSWarning" },
    ["@conceal"] = { link = "Grey" },
    ["@conditional"] = { link = "TSConditional" },
    ["@constant"] = { link = "TSConstant" },
    ["@constant.builtin"] = { link = "TSConstBuiltin" },
    ["@constant.builtin.go"] = { link = "goTSConstBuiltin" },
    ["@constant.builtin.yaml"] = { link = "yamlTSConstBuiltin" },
    ["@constant.macro"] = { link = "TSConstMacro" },
    ["@constant.regex"] = { link = "TSConstBuiltin" },
    ["@constructor"] = { link = "TSConstructor" },
    ["@constructor.lua"] = { link = "luaTSConstructor" },
    ["@constructor.tsx"] = { link = "tsxTSConstructor" },
    ["@debug"] = { link = "TSDebug" },
    ["@define"] = { link = "TSDefine" },
    ["@diff.delta"] = { link = "diffChanged" },
    ["@diff.minus"] = { link = "diffRemoved" },
    ["@diff.plus"] = { link = "diffAdded" },
    ["@error"] = { link = "TSError" }, -- This has been removed from nvim-treesitter
    ["@exception"] = { link = "TSException" },
    ["@field"] = { link = "TSField" },
    ["@field.yaml"] = { link = "yamlTSField" },
    ["@float"] = { link = "TSFloat" },
    ["@function"] = { link = "TSFunction" },
    ["@function.builtin"] = { link = "TSFuncBuiltin" },
    ["@function.call"] = { link = "TSFunctionCall" },
    ["@function.macro"] = { link = "TSFuncMacro" },
    ["@function.method"] = { link = "TSMethod" },
    ["@function.method.call"] = { link = "TSMethodCall" },
    ["@include"] = { link = "TSInclude" },
    ["@include.go"] = { link = "goTSInclude" },
    ["@include.javascript"] = { link = "javascriptTSInclude" },
    ["@include.typescript"] = { link = "typescriptTSInclude" },
    ["@keyword"] = { link = "TSKeyword" },
    ["@keyword.conditional"] = { link = "TSConditional" },
    ["@keyword.debug"] = { link = "TSDebug" },
    ["@keyword.directive"] = { link = "TSPreProc" },
    ["@keyword.directive.define"] = { link = "TSDefine" },
    ["@keyword.exception"] = { link = "TSException" },
    ["@keyword.function"] = { link = "TSKeywordFunction" },
    ["@keyword.import"] = { link = "TSInclude" },
    ["@keyword.import.go"] = { link = "goTSInclude" },
    ["@keyword.import.javascript"] = { link = "javascriptTSInclude" },
    ["@keyword.import.typescript"] = { link = "typescriptTSInclude" },
    ["@keyword.modifier"] = { link = "TSTypeQualifier" },
    ["@keyword.operator"] = { link = "TSKeywordOperator" },
    ["@keyword.repeat"] = { link = "TSRepeat" },
    ["@keyword.return"] = { link = "TSKeywordReturn" },
    ["@keyword.storage"] = { link = "TSStorageClass" },
    ["@label"] = { link = "TSLabel" },
    ["@label.json"] = { link = "jsonTSLabel" },
    ["@markup.emphasis"] = { link = "TSEmphasis" },
    ["@markup.environment"] = { link = "TSEnvironment" },
    ["@markup.environment.name"] = { link = "TSEnvironmentName" },
    ["@markup.heading"] = { link = "TSTitle" },
    ["@markup.heading.1.markdown"] = { link = "markdownH1" },
    ["@markup.heading.2.markdown"] = { link = "markdownH2" },
    ["@markup.heading.3.markdown"] = { link = "markdownH3" },
    ["@markup.heading.4.markdown"] = { link = "markdownH4" },
    ["@markup.heading.5.markdown"] = { link = "markdownH5" },
    ["@markup.heading.6.markdown"] = { link = "markdownH6" },
    ["@markup.heading.1.marker.markdown"] = { link = "@conceal" },
    ["@markup.heading.2.marker.markdown"] = { link = "@conceal" },
    ["@markup.heading.3.marker.markdown"] = { link = "@conceal" },
    ["@markup.heading.4.marker.markdown"] = { link = "@conceal" },
    ["@markup.heading.5.marker.markdown"] = { link = "@conceal" },
    ["@markup.heading.6.marker.markdown"] = { link = "@conceal" },
    ["@markup.italic"] = { link = "TSEmphasis" },
    ["@markup.link"] = { link = "TSTextReference" },
    ["@markup.link.label"] = { link = "TSStringSpecial" },
    ["@markup.link.url"] = { link = "TSURI" },
    ["@markup.list"] = { link = "TSPunctSpecial" },
    ["@markup.list.checked"] = { link = "Green" },
    ["@markup.list.unchecked"] = { link = "Ignore" },
    ["@markup.math"] = { link = "TSMath" },
    ["@markup.quote"] = { link = "Grey" },
    ["@markup.raw"] = { link = "TSLiteral" },
    ["@markup.strike"] = { link = "TSStrike" },
    ["@markup.strong"] = { link = "TSStrong" },
    ["@markup.underline"] = { link = "TSUnderline" },
    ["@math"] = { link = "TSMath" },
    ["@method"] = { link = "TSMethod" },
    ["@method.call"] = { link = "TSMethodCall" },
    ["@module"] = { link = "TSNamespace" },
    ["@module.go"] = { link = "goTSNamespace" },
    ["@namespace"] = { link = "TSNamespace" },
    ["@namespace.go"] = { link = "goTSNamespace" },
    ["@none"] = { link = "TSNone" },
    ["@number"] = { link = "TSNumber" },
    ["@number.float"] = { link = "TSFloat" },
    ["@operator"] = { link = "TSOperator" },
    ["@parameter"] = { link = "TSParameter" },
    ["@parameter.reference"] = { link = "TSParameterReference" },
    ["@preproc"] = { link = "TSPreProc" },
    ["@property"] = { link = "TSProperty" },
    ["@property.toml"] = { link = "tomlTSProperty" },
    ["@punctuation.bracket"] = { link = "TSPunctBracket" },
    ["@punctuation.bracket.regex"] = { link = "TSStringRegex" },
    ["@punctuation.delimiter"] = { link = "TSPunctDelimiter" },
    ["@punctuation.special"] = { link = "TSPunctSpecial" },
    ["@punctuation.special.typescript"] = { link = "TSOperator" },
    ["@repeat"] = { link = "TSRepeat" },
    ["@storageclass"] = { link = "TSStorageClass" },
    ["@storageclass.lifetime"] = { link = "TSStorageClassLifetime" },
    ["@strike"] = { link = "TSStrike" },
    ["@string"] = { link = "TSString" },
    ["@string.escape"] = { link = "TSStringEscape" },
    ["@string.escape.json"] = { link = "jsonTSStringEscape" },
    ["@string.escape.yaml"] = { link = "yamlTSStringEscape" },
    ["@string.json"] = { link = "jsonTSString" },
    ["@string.regex"] = { link = "TSStringRegex" },
    ["@string.regexp"] = { link = "TSStringRegex" },
    ["@string.special"] = { link = "TSStringSpecial" },
    ["@string.special.symbol"] = { link = "TSSymbol" },
    ["@string.special.url"] = { link = "TSURI" },
    ["@string.toml"] = { link = "tomlTSString" },
    ["@string.yaml"] = { link = "yamlTSString" },
    ["@symbol"] = { link = "TSSymbol" },
    ["@tag"] = { link = "TSTag" },
    ["@tag.attribute"] = { link = "TSTagAttribute" },
    ["@tag.delimiter"] = { link = "TSTagDelimiter" },
    ["@constructor"] = syntax_entry(syn.jsx_component, palette.none),
    ["@text"] = { link = "TSText" },
    ["@text.danger"] = { link = "TSDanger" },
    ["@text.diff.add"] = { link = "diffAdded" },
    ["@text.diff.delete"] = { link = "diffRemoved" },
    ["@text.emphasis"] = { link = "TSEmphasis" },
    ["@text.environment"] = { link = "TSEnvironment" },
    ["@text.environment.name"] = { link = "TSEnvironmentName" },
    ["@text.gitcommit"] = { link = "TSNone" },
    ["@text.html"] = { link = "htmlTSText" },
    ["@text.literal"] = { link = "TSLiteral" },
    ["@text.math"] = { link = "TSMath" },
    ["@text.note"] = { link = "TSNote" },
    ["@text.reference"] = { link = "TSTextReference" },
    ["@text.strike"] = { link = "TSStrike" },
    ["@text.strong"] = { link = "TSStrong" },
    ["@text.title"] = { link = "TSTitle" },
    ["@text.todo"] = { link = "TSTodo" },
    ["@text.todo.checked"] = { link = "Green" },
    ["@text.todo.unchecked"] = { link = "Ignore" },
    ["@text.underline"] = { link = "TSUnderline" },
    ["@text.uri"] = { link = "TSURI" },
    ["@text.warning"] = { link = "TSWarning" },
    ["@todo"] = { link = "TSTodo" },
    ["@type"] = { link = "TSType" },
    ["@type.builtin"] = { link = "TSTypeBuiltin" },
    ["@type.definition"] = { link = "TSTypeDefinition" },
    ["@type.qualifier"] = { link = "TSTypeQualifier" },
    ["@uri"] = { link = "TSURI" },
    ["@variable"] = { link = "TSVariable" },
    ["@variable.builtin"] = { link = "TSVariableBuiltin" },
    ["@variable.member"] = { link = "TSField" },
    ["@variable.member.yaml"] = { link = "yamlTSField" },
    ["@variable.parameter"] = { link = "TSParameter" },

    -- LSP Semantic token highlights
    ["@lsp.type.boolean"] = { link = "@boolean" },
    ["@lsp.type.builtinConstant"] = { link = "@constant.builtin" },
    ["@lsp.type.builtinType"] = { link = "@type.builtin" },
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.comment"] = { link = "@comment" },
    ["@lsp.type.decorator"] = { link = "@function" },
    ["@lsp.type.derive"] = { link = "@constructor" },
    ["@lsp.type.deriveHelper"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@property" },
    ["@lsp.type.escapeSequence"] = { link = "@string.escape" },
    ["@lsp.type.formatSpecifier"] = { link = "@punctuation.special" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.generic"] = { link = "@text" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.lifetime"] = { link = "@storageclass.lifetime" },
    ["@lsp.type.macro"] = { link = "@constant.macro" },
    ["@lsp.type.magicFunction"] = { link = "@function.builtin" },
    ["@lsp.type.method"] = { link = "@method" },
    ["@lsp.type.modifier"] = { link = "@type.qualifier" },
    ["@lsp.type.namespace"] = { link = "@namespace" },
    ["@lsp.type.namespace.go"] = { link = "@namespace.go" },
    ["@lsp.type.number"] = { link = "@number" },
    ["@lsp.type.operator"] = { link = "@operator" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.regexp"] = { link = "@string.regex" },
    ["@lsp.type.selfKeyword"] = { link = "@variable.builtin" },
    ["@lsp.type.selfTypeKeyword"] = { link = "@type" },
    ["@lsp.type.string"] = { link = "@string" },
    ["@lsp.type.struct"] = { link = "@type" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeAlias"] = { link = "@type.definition" },
    ["@lsp.type.typeParameter"] = { link = "@type.definition" },
    ["@lsp.type.variable"] = { link = "@variable" },
    ["@lsp.typemod.class.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.enum.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.function.readonly"] = { link = "@method" },
    ["@lsp.typemod.keyword.async"] = { link = "@keyword" },
    ["@lsp.typemod.keyword.injected"] = { link = "@keyword" },
    ["@lsp.typemod.macro.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.method.readonly"] = { link = "@method" },
    ["@lsp.typemod.operator.injected"] = { link = "@operator" },
    ["@lsp.typemod.string.injected"] = { link = "@string" },
    ["@lsp.typemod.struct.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.type.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.typeAlias.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.variable.callable"] = { link = "@function" },
    ["@lsp.typemod.variable.constant.rust"] = { link = "@constant" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.defaultLibrary.go"] = { link = "@constant.builtin.go" },
    ["@lsp.typemod.variable.defaultLibrary.javascript"] = { link = "@constant.builtin" },
    ["@lsp.typemod.variable.defaultLibrary.javascriptreact"] = { link = "@constant.builtin" },
    ["@lsp.typemod.variable.defaultLibrary.typescript"] = { link = "@constant.builtin" },
    ["@lsp.typemod.variable.defaultLibrary.typescriptreact"] = { link = "@constant.builtin" },
    ["@lsp.typemod.variable.injected"] = { link = "@variable" },
    ["@lsp.typemod.variable.static"] = { link = "Red" },

    -- HiPhish/rainbow-delimiters (kept)
    RainbowDelimiterRed = { link = "Red" },
    RainbowDelimiterOrange = { link = "Orange" },
    RainbowDelimiterYellow = { link = "Yellow" },
    RainbowDelimiterGreen = { link = "Green" },
    RainbowDelimiterCyan = { link = "Aqua" },
    RainbowDelimiterBlue = { link = "Blue" },
    RainbowDelimiterViolet = { link = "Purple" },

    -- Diff
    diffAdded = { link = "Added" },
    diffRemoved = { link = "Removed" },
    diffChanged = { link = "Changed" },
    diffOldFile = { link = "Yellow" },
    diffNewFile = { link = "Orange" },
    diffFile = { link = "Aqua" },
    diffLine = { link = "Grey" },
    diffIndexLine = { link = "Purple" },

    -- machakann/vim-highlightedyank
    HighlightedyankRegion = { link = "Visual" },

    -- Increase contrast for Copilot ghost suggestions
    -- Inline AI ghost text (Copilot / native LSP suggestion ghost)
    -- Use a mid-contrast foreground distinct from Normal fg & CursorLine bg.
    -- palette.outline was too faint on some surfaces; switch to ui.on_surface_variant for better legibility.
    CopilotSuggestion = syntax_entry(ui.primary, palette.error_container, { styles.italic, styles.nocombine }),
    ComplHint = syntax_entry(ui.on_surface_variant, palette.none, { styles.italic, styles.nocombine }),

    -- dominikduda/vim_current_word
    CurrentWordTwins = { link = "CurrentWord" },

    -- RRethy/vim-illuminate (kept minimal)
    IlluminatedWordText = { link = "CurrentWord" },
    IlluminatedWordRead = { link = "CurrentWord" },
    IlluminatedWordWrite = { link = "CurrentWord" },

    -- folke/which-key.nvim
    WhichKey = { link = "Red" },
    WhichKeyDesc = { link = "Blue" },
    WhichKeyFloat = syntax_entry(palette.none, palette.surface),
    WhichKeyGroup = { link = "Yellow" },
    WhichKeySeparator = { link = "Green" },
    WhichKeyValue = syntax_entry(palette.on_surface, palette.none),

    -- unblevable/quick-scope
    QuickScopePrimary = syntax_entry(palette.secondary, palette.none, { styles.underline }),
    QuickScopeSecondary = syntax_entry(palette.info, palette.none, { styles.underline }),

    -- APZelos/blamer.nvim (kept)
    Blamer = { link = "Grey" },

    -- hrsh7th/nvim-cmp
    CmpItemAbbrMatch = syntax_entry(palette.success, palette.none, { styles.bold }),
    CmpItemAbbrMatchFuzzy = syntax_entry(palette.success, palette.none, { styles.bold }),
    CmpItemAbbr = { link = "Fg" },
    CmpItemAbbrDeprecated = { link = "Grey" },
    CmpItemMenu = { link = "Fg" },
    CmpItemKind = { link = "Yellow" },

    -- folke/trouble.nvim
    TroubleText = { link = "Fg" },
    TroubleSource = { link = "Grey" },
    TroubleCode = { link = "Grey" },

    -- nvim-telescope/telescope.nvim
    TelescopeMatching = syntax_entry(palette.success, palette.none, { styles.bold }),
    TelescopeBorder = { link = "Grey" },
    TelescopePromptPrefix = { link = "Orange" },
    TelescopeSelection = { link = "DiffAdd" },

    -- ighagwan/fzf-lua
    FzfLuaBorder = { link = "Grey" },

    -- folke/snacks.nvim
    SnacksPicker = { link = "Normal" },
    SnacksPickerBorder = { link = "Grey" },
    SnacksPickerTitle = { link = "Title" },
    SnacksPickerFooter = { link = "SnacksPickerTitle" },
    SnacksPickerPrompt = { link = "Orange" },
    SnacksPickerInputCursorLine = { link = "Normal" },
    SnacksPickerListCursorLine = { link = "DiffAdd" },
    SnacksPickerMatch = syntax_entry(palette.success, palette.none, { styles.bold }),
    SnacksPickerToggle = { link = "CursorLine" },
    SnacksPickerDir = { link = "Comment" },
    SnacksPickerBufFlags = { link = "Grey" },
    SnacksPickerSelected = { link = "Aqua" },
    SnacksPickerKeymapRhs = { link = "Grey" },

    -- folke/sidekick.nvim
    SidekickDiffAdd = { link = "DiffAdd" },
    SidekickDiffContext = { link = "DiffChange" },
    SidekickDiffDelete = { link = "DiffDelete" },
    SidekickSignAdd = {
      fg = "#449dab",
    },
    SidekickSignChange = {
      fg = "#6183bb",
    },
    SidekickSignDelete = {
      fg = "#914c54",
    },

    -- lewis6991/gitsigns.nvim
    GitSignsAdd = { link = "GreenSign" },
    GitSignsChange = { link = "BlueSign" },
    GitSignsDelete = { link = "RedSign" },
    GitSignsAddNr = { link = "Green" },
    GitSignsChangeNr = { link = "Blue" },
    GitSignsDeleteNr = { link = "Red" },
    GitSignsAddLn = { link = "DiffAdd" },
    GitSignsChangeLn = { link = "DiffChange" },
    GitSignsDeleteLn = { link = "DiffDelete" },
    GitSignsCurrentLineBlame = { link = "Grey" },

    -- folke/flash.nvim
    FlashBackdrop = syntax_entry(palette.on_surface_variant, palette.none),
    FlashLabel = syntax_entry(palette.warning, palette.none, { styles.bold, styles.italic }),
    FlashMatch = syntax_entry(palette.warning, palette.none, { styles.bold }),
    FlashCurrent = syntax_entry(palette.warning, palette.none, { styles.bold }),

    -- ggandor/leap.nvim (kept)
    LeapMatch = syntax_entry(palette.on_surface, palette.tertiary, { styles.bold }),
    LeapLabel = syntax_entry(palette.tertiary, palette.none, { styles.bold }),
    LeapBackdrop = syntax_entry(palette.on_surface_variant, palette.none),

    -- lukas-reineke/indent-blankline.nvim
    IblScope = syntax_entry(palette.on_surface_variant, palette.none, { styles.nocombine }),
    IblIndent = syntax_entry(palette.bg4, palette.none, { styles.nocombine }),
    IndentBlanklineContextChar = { link = "IblScope" },
    IndentBlanklineChar = { link = "IblIndent" },
    IndentBlanklineSpaceChar = { link = "IndentBlanklineChar" },
    IndentBlanklineSpaceCharBlankline = { link = "IndentBlanklineChar" },

    BlinkCmpLabelMatch = syntax_entry(palette.none, palette.primary_container, { styles.bold }),
    BlinkCmpKind = { link = "Yellow" },

    -- SmiteshP/nvim-navic (kept)
    NavicText = syntax_entry(palette.on_surface, palette.none),
    NavicSeparator = syntax_entry(palette.on_surface, palette.none),

    -- rcarriga/nvim-notify
    NotifyBackground = syntax_entry(palette.none, palette.background),
    -- Borders
    NotifyDEBUGBorder = { link = "Grey" },
    NotifyERRORBorder = { link = "Red" },
    NotifyINFOBorder = { link = "Green" },
    NotifyTRACEBorder = { link = "Purple" },
    NotifyWARNBorder = { link = "Yellow" },

    -- Icons
    NotifyDEBUGIcon = { link = "Grey" },
    NotifyERRORIcon = { link = "Red" },
    NotifyINFOIcon = { link = "Green" },
    NotifyTRACEIcon = { link = "Purple" },
    NotifyWARNIcon = { link = "Yellow" },

    -- Titles
    NotifyDEBUGTitle = { link = "Grey" },
    NotifyERRORTitle = { link = "Red" },
    NotifyINFOTitle = { link = "Green" },
    NotifyTRACETitle = { link = "Purple" },
    NotifyWARNTitle = { link = "Yellow" },

    -- rcarriga/nvim-dap-ui
    DapUIModifiedValue = syntax_entry(palette.info, palette.none, { styles.bold }),
    DapUIBreakpointsCurrentLine = syntax_entry(palette.info, palette.none, { styles.bold }),
    DapUIPlayPause = syntax_entry(palette.success, palette.surface_variant),
    DapUIRestart = syntax_entry(palette.success, palette.surface_variant),
    DapUIStop = syntax_entry(palette.error, palette.surface_variant),
    DapUIUnavailable = syntax_entry(palette.on_surface_variant, palette.surface_variant),
    DapUIStepOver = syntax_entry(palette.info, palette.surface_variant),
    DapUIStepInto = syntax_entry(palette.info, palette.surface_variant),
    DapUIStepBack = syntax_entry(palette.info, palette.surface_variant),
    DapUIStepOut = syntax_entry(palette.info, palette.surface_variant),
    DapUIScope = { link = "Blue" },
    DapUIType = { link = "Purple" },
    DapUIDecoration = { link = "Blue" },
    DapUIThread = { link = "Green" },
    DapUIStoppedThread = { link = "Blue" },
    DapUISource = { link = "Purple" },
    DapUILineNumber = { link = "Blue" },
    DapUIFloatBorder = { link = "Blue" },
    DapUIWatchesEmpty = { link = "Red" },
    DapUIWatchesValue = { link = "Green" },
    DapUIWatchesError = { link = "Red" },
    DapUIBreakpointsPath = { link = "Blue" },
    DapUIBreakpointsInfo = { link = "Green" },

    -- (Removed lspsaga legacy groups)

    -- b0o/incline.nvim (kept)
    InclineNormalNC = syntax_entry(palette.on_surface_variant, palette.surface_variant),

    -- echasnovski/mini.nvim
    MiniAnimateCursor = syntax_entry(palette.none, palette.none, { styles.reverse, styles.nocombine }),
    MiniFilesFile = syntax_entry(palette.on_surface, palette.none),
    MiniFilesTitleFocused = syntax_entry(
      palette.success,
      options.float_style == "dim" and palette.background or palette.surface_variant,
      { styles.bold }
    ),
    MiniHipatternsFixme = syntax_entry(palette.background, palette.error, { styles.bold }),
    MiniHipatternsHack = syntax_entry(palette.background, palette.warning, { styles.bold }),
    MiniHipatternsNote = syntax_entry(palette.background, palette.info, { styles.bold }),
    MiniHipatternsTodo = syntax_entry(palette.background, palette.success, { styles.bold }),
    -- mini.nvim icons (subset kept)
    MiniIconsAzure = syntax_entry(palette.info, palette.none),
    MiniIconsBlue = syntax_entry(palette.info, palette.none),
    MiniIconsCyan = syntax_entry(palette.secondary, palette.none),
    MiniIconsGreen = syntax_entry(palette.success, palette.none),
    MiniIconsGrey = syntax_entry(palette.on_surface_variant, palette.none),
    MiniIconsOrange = syntax_entry(palette.warning, palette.none),
    MiniIconsPurple = syntax_entry(palette.tertiary, palette.none),
    MiniIconsRed = syntax_entry(palette.error, palette.none),
    MiniIconsYellow = syntax_entry(palette.warning, palette.none),
    MiniIndentscopePrefix = syntax_entry(palette.none, palette.none, { styles.nocombine }),
    MiniJump2dSpot = syntax_entry(palette.warning, palette.none, { styles.bold, styles.nocombine }),
    MiniJump2dSpotAhead = syntax_entry(palette.secondary, palette.none, { styles.nocombine }),
    MiniJump2dSpotUnique = syntax_entry(palette.warning, palette.none, { styles.bold, styles.nocombine }),
    MiniPickPrompt = syntax_entry(
      palette.info,
      options.float_style == "dim" and palette.background or palette.surface_variant
    ),
    MiniStarterCurrent = syntax_entry(palette.none, palette.none, { styles.nocombine }),
    MiniStatuslineDevinfo = syntax_entry(palette.on_surface_variant, palette.surface),
    MiniStatuslineFilename = syntax_entry(palette.on_surface_variant, palette.surface),
    MiniStatuslineModeCommand = syntax_entry(palette.background, palette.secondary, { styles.bold }),
    MiniStatuslineModeInsert = syntax_entry(palette.background, palette.secondary, { styles.bold }),
    MiniStatuslineModeNormal = syntax_entry(palette.background, palette.primary, { styles.bold }),
    MiniStatuslineModeOther = syntax_entry(palette.background, palette.tertiary, { styles.bold }),
    MiniStatuslineModeReplace = syntax_entry(palette.background, palette.warning, { styles.bold }),
    MiniStatuslineModeVisual = syntax_entry(palette.background, palette.tertiary, { styles.bold }),
    MiniTablineCurrent = syntax_entry(palette.success, palette.background, { styles.bold }),
    MiniTablineHidden = syntax_entry(palette.on_surface_variant, palette.surface_variant),
    MiniTablineModifiedCurrent = syntax_entry(palette.surface, palette.success),
    MiniTablineModifiedHidden = syntax_entry(palette.warning, palette.surface_variant),
    MiniTablineModifiedVisible = syntax_entry(palette.warning, palette.surface_variant),
    MiniTablineTabpagesection = syntax_entry(palette.background, palette.primary, { styles.bold }),
    MiniTablineVisible = syntax_entry(palette.on_surface, palette.surface_variant),
    MiniTestEmphasis = syntax_entry(palette.none, palette.none, { styles.bold }),
    MiniTestFail = syntax_entry(palette.error, palette.none, { styles.bold }),
    MiniTestPass = syntax_entry(palette.success, palette.none, { styles.bold }),
    MiniTrailspace = syntax_entry(palette.none, palette.error),
    MiniAnimateNormalFloat = { link = "NormalFloat" },
    MiniClueBorder = { link = "FloatBorder" },
    MiniClueDescGroup = { link = "DiagnosticFloatingWarn" },
    MiniClueDescSingle = { link = "NormalFloat" },
    MiniClueNextKey = { link = "DiagnosticFloatingHint" },
    MiniClueNextKeyWithPostkeys = { link = "DiagnosticFloatingError" },
    MiniClueSeparator = { link = "DiagnosticFloatingInfo" },
    MiniClueTitle = { link = "FloatTitle" },
    MiniCompletionActiveParameter = { link = "LspSignatureActiveParameter" },
    MiniCursorword = { link = "CurrentWord" },
    MiniCursorwordCurrent = { link = "CurrentWord" },
    MiniDepsChangeAdded = { link = "Added" },
    MiniDepsChangeRemoved = { link = "Removed" },
    MiniDepsHints = { link = "DiagnosticHint" },
    MiniDepsInfo = { link = "DiagnosticInfo" },
    MiniDepsMsgBreaking = { link = "DiagnosticWarn" },
    MiniDepsPlaceholder = { link = "Comment" },
    MiniDepsTitle = { link = "Title" },
    MiniDepsTitleError = { link = "DiffDelete" },
    MiniDepsTitleSame = { link = "DiffChange" },
    MiniDepsTitleUpdate = { link = "DiffAdd" },
    MiniDiffOverAdd = { link = "DiffAdd" },
    MiniDiffOverChange = { link = "DiffText" },
    MiniDiffOverContext = { link = "DiffChange" },
    MiniDiffOverDelete = { link = "DiffDelete" },
    MiniDiffSignAdd = { link = "GreenSign" },
    MiniDiffSignChange = { link = "BlueSign" },
    MiniDiffSignDelete = { link = "RedSign" },
    MiniFilesBorder = { link = "FloatBorder" },
    MiniFilesBorderModified = { link = "DiagnosticFloatingWarn" },
    MiniFilesCursorLine = { link = "CursorLine" },
    MiniFilesDirectory = { link = "Directory" },
    MiniFilesNormal = { link = "NormalFloat" },
    MiniFilesTitle = { link = "FloatTitle" },
    MiniIndentscopeSymbol = { link = "Grey" },
    MiniJump = { link = "Search" },
    MiniJump2dDim = { link = "Comment" },
    MiniMapNormal = { link = "NormalFloat" },
    MiniMapSymbolCount = { link = "Special" },
    MiniMapSymbolLine = { link = "Title" },
    MiniMapSymbolView = { link = "Delimiter" },
    MiniNotifyBorder = { link = "FloatBorder" },
    MiniNotifyNormal = { link = "NormalFloat" },
    MiniNotifyTitle = { link = "FloatTitle" },
    MiniOperatorsExchangeFrom = { link = "IncSearch" },
    MiniPickBorder = { link = "FloatBorder" },
    MiniPickBorderBusy = { link = "DiagnosticFloatingWarn" },
    MiniPickBorderText = { link = "FloatTitle" },
    MiniPickHeader = { link = "DiagnosticFloatingHint" },
    MiniPickIconDirectory = { link = "Directory" },
    MiniPickIconFile = { link = "MiniPickNormal" },
    MiniPickMatchCurrent = { link = "CursorLine" },
    MiniPickMatchMarked = { link = "Visual" },
    MiniPickMatchRanges = { link = "DiagnosticFloatingHint" },
    MiniPickNormal = { link = "NormalFloat" },
    MiniPickPreviewLine = { link = "CursorLine" },
    MiniPickPreviewRegion = { link = "IncSearch" },
    MiniStarterFooter = { link = "Orange" },
    MiniStarterHeader = { link = "Yellow" },
    MiniStarterInactive = { link = "Comment" },
    MiniStarterItem = { link = "Normal" },
    MiniStarterItemBullet = { link = "Grey" },
    MiniStarterItemPrefix = { link = "Yellow" },
    MiniStarterQuery = { link = "Blue" },
    MiniStarterSection = { link = "Title" },
    MiniStatuslineFileinfo = { link = "MiniStatuslineDevinfo" },
    MiniStatuslineInactive = { link = "Grey" },
    MiniSurround = { link = "IncSearch" },
    MiniTablineFill = { link = "TabLineFill" },

    -- https://github.com/simrat39/symbols-outline.nvim
    FocusedSymbol = { link = "NormalFloat" },

    -- nvim-neotest/neotest
    NeotestPassed = { link = "GreenSign" },
    NeotestRunning = { link = "YellowSign" },
    NeotestFailed = { link = "RedSign" },
    NeotestSkipped = { link = "BlueSign" },
    NeotestNamespace = { link = "Purple" },
    NeotestFocused = syntax_entry(palette.warning, palette.none),
    NeotestFile = { link = "Aqua" },
    NeotestDir = { link = "Directory" },
    NeotestBorder = syntax_entry(palette.info, palette.none),
    NeotestIndent = { link = "NonText" },
    NeotestExpandMarker = syntax_entry(palette.bg5, palette.none),
    NeotestAdapterName = { link = "Title" },
    NeotestWinSelect = syntax_entry(palette.info, palette.none),
    NeotestMarked = { link = "Orange" },
    NeotestTarget = { link = "Red" },

    -- (Removed glyph-palette legacy groups)

    -- akinsho/bufferline.nvim
    BufferLineIndicatorSelected = { link = "GreenSign" },

    -- petertriho/nvim-scrollbar
    ScrollbarHandle = syntax_entry(palette.none, palette.surface),
    ScrollbarSearchHandle = syntax_entry(palette.warning, palette.surface),
    ScrollbarSearch = syntax_entry(palette.warning, palette.none),
    ScrollbarErrorHandle = syntax_entry(palette.error, palette.surface),
    ScrollbarError = syntax_entry(palette.error, palette.none),
    ScrollbarWarnHandle = syntax_entry(palette.warning, palette.surface),
    ScrollbarWarn = syntax_entry(palette.warning, palette.none),
    ScrollbarInfoHandle = syntax_entry(palette.success, palette.surface),
    ScrollbarInfo = syntax_entry(palette.success, palette.none),
    ScrollbarHintHandle = syntax_entry(palette.info, palette.surface),
    ScrollbarHint = syntax_entry(palette.info, palette.none),
    ScrollbarMiscHandle = syntax_entry(palette.tertiary, palette.surface),
    ScrollbarMisc = syntax_entry(palette.tertiary, palette.none),

    -- gbprod/yanky.nvim
    YankyPut = { link = "IncSearch" },
    YankyYanked = { link = "IncSearch" },

    -- folke/noice.nvim
    NoiceCompletionItemKindDefault = syntax_entry(palette.on_surface_variant, palette.none),
    NoiceCompletionItemKindKeyword = syntax_entry(palette.secondary, palette.none),
    NoiceCompletionItemKindVariable = syntax_entry(palette.tertiary, palette.none),
    NoiceCompletionItemKindConstant = syntax_entry(palette.tertiary, palette.none),
    NoiceCompletionItemKindReference = syntax_entry(palette.tertiary, palette.none),
    NoiceCompletionItemKindValue = syntax_entry(palette.tertiary, palette.none),
    NoiceCompletionItemKindFunction = syntax_entry(palette.info, palette.none),
    NoiceCompletionItemKindMethod = syntax_entry(palette.info, palette.none),
    NoiceCompletionItemKindConstructor = syntax_entry(palette.info, palette.none),
    NoiceCompletionItemKindClass = syntax_entry(palette.warning, palette.none),
    NoiceCompletionItemKindInterface = syntax_entry(palette.warning, palette.none),
    NoiceCompletionItemKindStruct = syntax_entry(palette.warning, palette.none),
    NoiceCompletionItemKindEvent = syntax_entry(palette.warning, palette.none),
    NoiceCompletionItemKindEnum = syntax_entry(palette.warning, palette.none),
    NoiceCompletionItemKindUnit = syntax_entry(palette.warning, palette.none),
    NoiceCompletionItemKindModule = syntax_entry(palette.warning, palette.none),
    NoiceCompletionItemKindProperty = syntax_entry(palette.success, palette.none),
    NoiceCompletionItemKindField = syntax_entry(palette.success, palette.none),
    NoiceCompletionItemKindTypeParameter = syntax_entry(palette.success, palette.none),
    NoiceCompletionItemKindEnumMember = syntax_entry(palette.success, palette.none),
    NoiceCompletionItemKindOperator = syntax_entry(palette.success, palette.none),
    NoiceCompletionItemKindSnippet = syntax_entry(palette.on_surface_variant, palette.none),

    -- williamboman/mason.nvim
    MasonHeader = syntax_entry(palette.background, palette.success, { styles.bold }),
    MasonHeaderSecondary = syntax_entry(palette.background, palette.warning, { styles.bold }),
    MasonHighlight = { link = "Green" },
    MasonHighlightSecondary = { link = "Yellow" },
    MasonHighlightBlock = syntax_entry(palette.background, palette.secondary),
    MasonHighlightBlockBold = syntax_entry(palette.background, palette.secondary, { styles.bold }),
    MasonHighlightBlockSecondary = syntax_entry(palette.background, palette.warning),
    MasonHighlightBlockBoldSecondary = syntax_entry(palette.background, palette.warning, { styles.bold }),
    MasonMuted = syntax_entry(palette.outline_variant, palette.none),
    MasonMutedBlock = syntax_entry(palette.background, palette.outline_variant),

    -- nullchilly/fsread.nvim (kept)
    FSPrefix = syntax_entry(palette.on_surface, transparency_respecting_colour(palette.background), { styles.bold }),
    FSSuffix = syntax_entry(palette.on_surface_variant, palette.none),

    -- Language specific settings (trimmed: prefer semantic Tree-sitter & LSP groups)
    -- Removed most per-language legacy groups for portability & reduced maintenance.
    -- Retained only markdown headings & link/url for readability; others can be mapped via TS captures.
    -- Markdown
    markdownH1 = syntax_entry(palette.error, palette.none, { styles.bold }),
    markdownH2 = syntax_entry(palette.warning, palette.none, { styles.bold }),
    markdownH3 = syntax_entry(palette.warning, palette.none, { styles.bold }),
    markdownH4 = syntax_entry(palette.success, palette.none, { styles.bold }),
    markdownH5 = syntax_entry(palette.info, palette.none, { styles.bold }),
    markdownH6 = syntax_entry(palette.tertiary, palette.none, { styles.bold }),
    markdownUrl = { link = "TSURI" },
    markdownItalic = syntax_entry(palette.none, palette.none, { styles.italic }),
    markdownBold = syntax_entry(palette.none, palette.none, { styles.bold }),
    markdownItalicDelimiter = syntax_entry(palette.on_surface_variant, palette.none, { styles.italic }),
    markdownCode = { link = "Green" },
    markdownCodeBlock = { link = "Aqua" },
    markdownCodeDelimiter = { link = "Aqua" },
    markdownBlockquote = { link = "Grey" },
    markdownListMarker = { link = "Red" },
    markdownOrderedListMarker = { link = "Red" },
    markdownRule = { link = "Purple" },
    markdownHeadingRule = { link = "Grey" },
    markdownUrlDelimiter = { link = "Grey" },
    markdownLinkDelimiter = { link = "Grey" },
    markdownLinkTextDelimiter = { link = "Grey" },
    markdownHeadingDelimiter = { link = "Grey" },
    markdownLinkText = { link = "Purple" },
    markdownUrlTitleDelimiter = { link = "Green" },
    markdownIdDeclaration = { link = "markdownLinkText" },
    markdownBoldDelimiter = { link = "Grey" },
    markdownId = { link = "Yellow" },

    -- HTML
    htmlH1 = syntax_entry(palette.error, palette.none, { styles.bold }),
    htmlH2 = syntax_entry(palette.warning, palette.none, { styles.bold }),
    htmlH3 = syntax_entry(palette.warning, palette.none, { styles.bold }),
    htmlH4 = syntax_entry(palette.success, palette.none, { styles.bold }),
    htmlH5 = syntax_entry(palette.info, palette.none, { styles.bold }),
    htmlH6 = syntax_entry(palette.tertiary, palette.none, { styles.bold }),
    htmlLink = syntax_entry(palette.none, palette.none, { styles.underline }),
    htmlBold = syntax_entry(palette.none, palette.none, { styles.bold }),
    htmlBoldUnderline = syntax_entry(palette.none, palette.none, { styles.bold, styles.underline }),
    htmlBoldItalic = syntax_entry(palette.none, palette.none, { styles.bold, styles.italic }),
    htmlBoldUnderlineItalic = syntax_entry(
      palette.none,
      palette.none,
      { styles.bold, styles.underline, styles.italic }
    ),
    htmlUnderline = syntax_entry(palette.none, palette.none, { styles.underline }),
    htmlUnderlineItalic = syntax_entry(palette.none, palette.none, { styles.underline, styles.italic }),
    htmlItalic = syntax_entry(palette.none, palette.none, { styles.italic }),
    htmlTag = { link = "Green" },
    htmlEndTag = { link = "Blue" },
    htmlTagN = { link = "OrangeItalic" },
    htmlTagName = { link = "OrangeItalic" },
    htmlArg = { link = "Aqua" },
    htmlScriptTag = { link = "Purple" },
    htmlSpecialTagName = { link = "RedItalic" },

    -- XML
    xmlTag = { link = "Green" },
    xmlEndTag = { link = "Blue" },
    xmlTagName = { link = "OrangeItalic" },
    xmlEqual = { link = "Orange" },
    xmlAttrib = { link = "Aqua" },
    xmlEntity = { link = "Red" },
    xmlEntityPunct = { link = "Red" },
    xmlDocTypeDecl = { link = "Grey" },
    xmlDocTypeKeyword = { link = "PurpleItalic" },
    xmlCdataStart = { link = "Grey" },
    xmlCdataCdata = { link = "Purple" },

    -- CSS
    cssAttrComma = { link = "Fg" },
    cssBraces = { link = "Fg" },
    cssTagName = { link = "PurpleItalic" },
    cssClassNameDot = { link = "Red" },
    cssClassName = { link = "RedItalic" },
    cssFunctionName = { link = "Yellow" },
    cssAttr = { link = "Orange" },
    cssProp = { link = "Aqua" },
    cssCommonAttr = { link = "Yellow" },
    cssPseudoClassId = { link = "Blue" },
    cssPseudoClassFn = { link = "Green" },
    cssPseudoClass = { link = "Purple" },
    cssImportant = { link = "RedItalic" },
    cssSelectorOp = { link = "Orange" },
    cssSelectorOp2 = { link = "Orange" },
    cssColor = { link = "Green" },
    cssAttributeSelector = { link = "Aqua" },
    cssUnitDecorators = { link = "Orange" },
    cssValueLength = { link = "Green" },
    cssValueInteger = { link = "Green" },
    cssValueNumber = { link = "Green" },
    cssValueAngle = { link = "Green" },
    cssValueTime = { link = "Green" },
    cssValueFrequency = { link = "Green" },
    cssVendor = { link = "Grey" },
    cssNoise = { link = "Grey" },

    -- SCSS
    scssMixinName = { link = "Yellow" },
    scssSelectorChar = { link = "Red" },
    scssSelectorName = { link = "RedItalic" },
    scssInterpolationDelimiter = { link = "Green" },
    scssVariableValue = { link = "Green" },
    scssNull = { link = "Purple" },
    scssBoolean = { link = "Purple" },
    scssVariableAssignment = { link = "Grey" },
    scssForKeyword = { link = "PurpleItalic" },
    scssAttribute = { link = "Orange" },
    scssFunctionName = { link = "Yellow" },

    -- SASS
    sassProperty = { link = "Aqua" },
    sassAmpersand = { link = "Orange" },
    sassClass = { link = "RedItalic" },
    sassClassChar = { link = "Red" },
    sassMixing = { link = "PurpleItalic" },
    sassMixinName = { link = "Orange" },
    sassCssAttribute = { link = "Yellow" },
    sassInterpolationDelimiter = { link = "Green" },
    sassFunction = { link = "Yellow" },
    sassControl = { link = "RedItalic" },
    sassFor = { link = "RedItalic" },
    sassFunctionName = { link = "Green" },

    -- Less
    lessMixinChar = { link = "Grey" },
    lessClass = { link = "RedItalic" },
    lessVariable = { link = "Blue" },
    lessAmpersandChar = { link = "Orange" },
    lessFunction = { link = "Yellow" },

    -- Python
    pythonBuiltin = { link = "Yellow" },
    pythonExceptions = { link = "Purple" },
    pythonDecoratorName = { link = "Blue" },

    -- Lua
    luaBraces = { link = "Fg" },
    luaFunc = { link = "Green" },
    luaFunction = { link = "Aqua" },
    luaTable = { link = "Fg" },
    luaIn = { link = "RedItalic" },

    -- Java
    javaClassDecl = { link = "RedItalic" },
    javaMethodDecl = { link = "RedItalic" },
    javaVarArg = { link = "Green" },
    javaAnnotation = { link = "Blue" },
    javaUserLabel = { link = "Purple" },
    javaTypedef = { link = "Aqua" },
    javaParen = { link = "Fg" },
    javaParen1 = { link = "Fg" },
    javaParen2 = { link = "Fg" },
    javaParen3 = { link = "Fg" },
    javaParen4 = { link = "Fg" },
    javaParen5 = { link = "Fg" },

    -- Go
    goPackage = { link = "Define" },
    goImport = { link = "Include" },
    goVar = { link = "OrangeItalic" },
    goConst = { link = "goVar" },
    goType = { link = "Yellow" },
    goSignedInts = { link = "goType" },
    goUnsignedInts = { link = "goType" },
    goFloats = { link = "goType" },
    goComplexes = { link = "goType" },
    goVarDefs = { link = "Aqua" },
    goDeclType = { link = "OrangeItalic" },
    goFunctionCall = { link = "Function" },
    goPredefinedIdentifiers = { link = "Aqua" },
    goBuiltins = { link = "Function" },
    goVarArgs = { link = "Grey" },

    -- Rust
    rustStructure = { link = "Orange" },
    rustIdentifier = { link = "Purple" },
    rustModPath = { link = "Orange" },
    rustModPathSep = { link = "Grey" },
    rustSelf = { link = "Blue" },
    rustSuper = { link = "Blue" },
    rustDeriveTrait = { link = "PurpleItalic" },
    rustEnumVariant = { link = "Purple" },
    rustMacroVariable = { link = "Blue" },
    rustAssert = { link = "Aqua" },
    rustPanic = { link = "Aqua" },
    rustPubScopeCrate = { link = "PurpleItalic" },

    -- PHP
    phpVarSelector = { link = "Blue" },
    phpDefine = { link = "OrangeItalic" },
    phpStructure = { link = "RedItalic" },
    phpSpecialFunction = { link = "Green" },
    phpInterpSimpleCurly = { link = "Yellow" },
    phpComparison = { link = "Orange" },
    phpMethodsVar = { link = "Aqua" },
    phpMemberSelector = { link = "Green" },

    -- sh/zsh
    shRange = { link = "Fg" },
    shTestOpr = { link = "Orange" },
    shOption = { link = "Aqua" },
    bashStatement = { link = "Orange" },
    shOperator = { link = "Orange" },
    shQuote = { link = "Green" },
    shSet = { link = "Orange" },
    shSetList = { link = "Blue" },
    shSnglCase = { link = "Orange" },
    shVariable = { link = "Blue" },
    shVarAssign = { link = "Orange" },
    shCmdSubRegion = { link = "Green" },
    shCommandSub = { link = "Orange" },
    shFunction = { link = "Green" },
    shFunctionKey = { link = "RedItalic" },

    -- ZSH
    zshOptStart = { link = "PurpleItalic" },
    zshOption = { link = "Blue" },
    zshSubst = { link = "Yellow" },
    zshFunction = { link = "Green" },
    zshDeref = { link = "Blue" },
    zshTypes = { link = "Orange" },
    zshVariableDef = { link = "Blue" },
  }

  if options.inlay_hints_background == "none" then
    syntax["InlayHints"] = { link = "LineNr" }
  elseif options.inlay_hints_background == "dimmed" then
    syntax["InlayHints"] = syntax_entry(palette.outline, palette.surface)
  elseif options.inlay_hints_background == "soft" then
    -- Blend surface towards background for a mid-tone capsule (~60% toward surface)
    local soft_bg = util.blend(palette.surface, 0.60, palette.background)
    syntax["InlayHints"] = syntax_entry(palette.outline, soft_bg)
  end

  local lsp_kind_colours = {
    Array = "Aqua",
    Boolean = "Aqua",
    Class = "Yellow",
    Color = "Aqua",
    Constant = "Blue",
    Constructor = "Green",
    Default = "Aqua",
    Enum = "Yellow",
    EnumMember = "Purple",
    Event = "Orange",
    Field = "Green",
    File = "Green",
    Folder = "Aqua",
    Function = "Green",
    Interface = "Yellow",
    Key = "Red",
    Keyword = "Red",
    Method = "Green",
    Module = "Yellow",
    Namespace = "Purple",
    Null = "Aqua",
    Number = "Aqua",
    Object = "Aqua",
    Operator = "Orange",
    Package = "Purple",
    Property = "Blue",
    Reference = "Aqua",
    Snippet = "Aqua",
    String = "Aqua",
    Struct = "Yellow",
    Text = "Fg",
    TypeParameter = "Yellow",
    Unit = "Purple",
    Value = "Purple",
    Variable = "Blue",
  }

  for kind, colour in pairs(lsp_kind_colours) do
    syntax["CmpItemKind" .. kind] = { link = colour }
    syntax["Aerial" .. kind .. "Icon"] = { link = colour }
    syntax["BlinkCmpKind" .. kind] = { link = colour }
  end

  -- yetone/avante.nvim
  syntax["AvanteTitle"] = syntax_entry(palette.background, palette.success, { styles.bold })
  syntax["AvanteReversedTitle"] = syntax_entry(palette.success, palette.none)
  syntax["AvanteSubtitle"] = syntax_entry(palette.background, palette.info, { styles.bold })
  syntax["AvanteReversedSubtitle"] = syntax_entry(palette.info, palette.none)
  syntax["AvanteThirdTitle"] = syntax_entry(palette.on_surface, palette.surface_variant, { styles.bold })
  syntax["AvanteReversedThirdTitle"] = syntax_entry(palette.surface_variant, palette.none)
  syntax["AvanteSuggestion"] = { link = "Comment" }
  syntax["AvanteAnnotation"] = { link = "Comment" }
  syntax["AvanteInlineHint"] = syntax_entry(palette.on_surface_variant, palette.none, { styles.italic })
  syntax["AvantePopupHint"] = { link = "NormalFloat" }
  syntax["AvanteConflictCurrent"] = syntax_entry(palette.none, palette.error_container, { styles.bold })
  syntax["AvanteConflictCurrentLabel"] = syntax_entry(util.darken(palette.error, 0.3), palette.error_container)
  syntax["AvanteConflictIncoming"] = syntax_entry(palette.none, palette.info_container, { styles.bold })
  syntax["AvanteConflictIncomingLabel"] = syntax_entry(util.darken(palette.info, 0.3), palette.info_container)
  syntax["AvanteToBeDeleted"] = syntax_entry(palette.none, palette.error_container, { styles.strikethrough })
  syntax["AvanteToBeDeletedWOStrikethrough"] = syntax_entry(palette.none, palette.error_container)
  syntax["AvanteButtonDefault"] = syntax_entry(palette.background, palette.on_surface_variant)
  syntax["AvanteButtonDefaultHover"] = syntax_entry(palette.background, palette.success)
  syntax["AvanteButtonPrimary"] = syntax_entry(palette.background, palette.info)
  syntax["AvanteButtonPrimaryHover"] = syntax_entry(palette.background, palette.secondary)
  syntax["AvanteButtonDanger"] = syntax_entry(palette.background, palette.error)
  syntax["AvanteButtonDangerHover"] = syntax_entry(palette.on_surface, palette.error)
  syntax["AvantePromptInput"] = syntax_entry(palette.on_surface, transparency_respecting_colour(palette.surface))
  syntax["AvantePromptInputBorder"] = { link = "NormalFloat" }
  syntax["AvanteConfirmTitle"] = syntax_entry(palette.background, palette.error, { styles.bold })
  syntax["AvanteSidebarNormal"] = { link = "NormalFloat" }
  syntax["AvanteSidebarWinSeparator"] = { link = "WinSeparator" }
  syntax["AvanteSidebarWinHorizontalSeparator"] =
    syntax_entry(palette.outline_variant, transparency_respecting_colour(palette.surface))
  syntax["AvanteReversedNormal"] = syntax_entry(transparency_respecting_colour(palette.background), palette.on_surface)
  syntax["AvanteCommentFg"] = { link = "Comment" }
  syntax["AvanteStateSpinnerGenerating"] = syntax_entry(palette.background, palette.tertiary)
  syntax["AvanteStateSpinnerToolCalling"] = syntax_entry(palette.background, palette.info)
  syntax["AvanteStateSpinnerFailed"] = syntax_entry(palette.background, palette.error)
  syntax["AvanteStateSpinnerSucceeded"] = syntax_entry(palette.background, palette.success)
  syntax["AvanteStateSpinnerSearching"] = syntax_entry(palette.background, palette.warning)
  syntax["AvanteStateSpinnerThinking"] = syntax_entry(palette.background, palette.secondary)
  syntax["AvanteStateSpinnerCompacting"] = syntax_entry(palette.background, palette.warning)
  syntax["AvanteTaskRunning"] = syntax_entry(palette.tertiary, transparency_respecting_colour(palette.background))
  syntax["AvanteTaskCompleted"] = syntax_entry(palette.success, transparency_respecting_colour(palette.background))
  syntax["AvanteTaskFailed"] = syntax_entry(palette.error, transparency_respecting_colour(palette.background))
  syntax["AvanteThinking"] = syntax_entry(palette.secondary, transparency_respecting_colour(palette.background))

  -- Terminal colours
  local terminal = {
    red = palette.error,
    yellow = palette.warning,
    green = palette.success,
    cyan = palette.secondary,
    blue = palette.info,
    purple = palette.tertiary,
  }

  if vim.o.background == "dark" then
    terminal.black = palette.on_surface
    terminal.white = palette.outline
  else
    terminal.black = palette.outline
    terminal.white = palette.on_surface
  end

  -- Consider adding configuration options for this
  vim.g.terminal_color_0 = terminal.black
  vim.g.terminal_color_8 = terminal.black

  vim.g.terminal_color_1 = terminal.red
  vim.g.terminal_color_9 = util.lighten(terminal.red, 0.5)

  vim.g.terminal_color_2 = terminal.green
  vim.g.terminal_color_10 = util.lighten(terminal.green, 0.5)

  vim.g.terminal_color_3 = terminal.yellow
  vim.g.terminal_color_11 = util.lighten(terminal.yellow, 0.5)

  vim.g.terminal_color_4 = terminal.blue
  vim.g.terminal_color_12 = util.lighten(terminal.blue, 0.5)

  vim.g.terminal_color_5 = terminal.purple
  vim.g.terminal_color_13 = util.lighten(terminal.purple, 0.5)

  vim.g.terminal_color_6 = terminal.cyan
  vim.g.terminal_color_14 = util.lighten(terminal.cyan, 0.5)

  vim.g.terminal_color_7 = terminal.white
  vim.g.terminal_color_15 = terminal.white

  -- junegunn/fzf.vim
  vim.g.fzf_colors = {
    fg = { "fg", "Normal" },
    bg = { "bg", "Normal" },
    hl = { "fg", "Green" },
    ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
    ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
    ["hl+"] = { "fg", "Aqua" },
    info = { "fg", "Aqua" },
    border = { "fg", "Grey" },
    prompt = { "fg", "Orange" },
    pointer = { "fg", "Blue" },
    marker = { "fg", "Yellow" },
    spinner = { "fg", "Yellow" },
    header = { "fg", "Grey" },
  }
  -- junegunn/limelight.vim
  vim.g.limelight_conceal_ctermfg = palette.outline_variant
  vim.g.limelight_conceal_guifg = palette.outline_variant

  if options.on_highlights then
    options.on_highlights(syntax, palette)
  end

  return syntax
end

return highlights
