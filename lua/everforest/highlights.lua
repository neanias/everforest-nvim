local highlights = {}

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

---@class Highlight
---@field fg string|nil
---@field bg string|nil
---@field sp string|nil
---@field style string|nil|Highlight
---@field link string|nil

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
---@param palette Palette
---@param options Config
---@return Highlights
highlights.generate_syntax = function(palette, options)
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
  ---
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
  local syntax = {
    Normal = syntax_entry(palette.fg, transparency_respecting_colour(palette.bg0)),
    NormalNC = syntax_entry(
      palette.fg,
      transparency_respecting_colour((options.dim_inactive_windows and palette.bg_dim) or palette.bg0)
    ),
    Terminal = syntax_entry(palette.fg, transparency_respecting_colour(palette.bg0)),
    EndOfBuffer = syntax_entry((options.show_eob and palette.bg4) or palette.bg0, palette.none),
    Folded = syntax_entry(palette.grey1, transparency_respecting_colour(palette.bg1)),
    SignColumn = syntax_entry(palette.fg, sign_column_respecting_colour(palette.bg1)),
    FoldColumn = syntax_entry(
      (options.sign_column_background == "grey" and palette.grey2) or palette.bg5,
      sign_column_respecting_colour(palette.bg1)
    ),
    ToolbarLine = syntax_entry(palette.fg, transparency_respecting_colour(palette.bg2)),
    IncSearch = syntax_entry(palette.bg0, palette.red),
    Search = syntax_entry(palette.bg0, palette.green),
    ColorColumn = syntax_entry(palette.none, palette.bg1),
    Conceal = syntax_entry(set_colour_based_on_ui_contrast(palette.bg5, palette.grey0), palette.none),
    Cursor = syntax_entry(palette.none, palette.none, { styles.reverse }),
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    CursorLine = syntax_entry(palette.none, palette.bg1),
    CursorColumn = syntax_entry(palette.none, palette.bg1),
    LineNr = syntax_entry(set_colour_based_on_ui_contrast(palette.bg5, palette.grey0), palette.none),
    CursorLineNr = syntax_entry(
      set_colour_based_on_ui_contrast(palette.grey1, palette.grey2),
      sign_column_respecting_colour(palette.bg1)
    ),

    DiffAdd = syntax_entry(palette.none, palette.bg_green),
    DiffChange = syntax_entry(palette.none, palette.bg_blue),
    DiffDelete = syntax_entry(palette.none, palette.bg_red),
    DiffText = syntax_entry(palette.bg0, palette.blue),
    Directory = syntax_entry(palette.green, palette.none),
    ErrorMsg = syntax_entry(palette.red, palette.none, { styles.bold, styles.underline }),
    WarningMsg = syntax_entry(palette.yellow, palette.none, { styles.bold }),
    ModeMsg = syntax_entry(palette.fg, palette.none, { styles.bold }),
    MoreMsg = syntax_entry(palette.yellow, palette.none, { styles.bold }),
    MatchParen = syntax_entry(palette.none, palette.bg4),
    NonText = syntax_entry(palette.bg4, palette.none),
    Whitespace = syntax_entry(palette.bg4, palette.none),
    SpecialKey = syntax_entry(palette.bg3, palette.none),
    Pmenu = syntax_entry(palette.fg, palette.bg2),
    PmenuSbar = syntax_entry(palette.none, palette.bg2),
    PmenuSel = syntax_entry(palette.bg0, palette.statusline1),
    WildMenu = { link = "PmenuSel" },
    PmenuThumb = syntax_entry(palette.none, palette.grey0),
    NormalFloat = syntax_entry(palette.fg, palette.bg2),
    FloatBorder = syntax_entry(palette.grey1, palette.bg2),
    Question = syntax_entry(palette.yellow, palette.none),

    SpellBad = syntax_entry(
      options.spell_foreground and palette.red or palette.none,
      palette.none,
      { styles.undercurl },
      palette.red
    ),
    SpellCap = syntax_entry(
      options.spell_foreground and palette.blue or palette.none,
      palette.none,
      { styles.undercurl },
      palette.blue
    ),
    SpellLocal = syntax_entry(
      options.spell_foreground and palette.aqua or palette.none,
      palette.none,
      { styles.undercurl },
      palette.aqua
    ),
    SpellRare = syntax_entry(
      options.spell_foreground and palette.purple or palette.none,
      palette.none,
      { styles.undercurl },
      palette.purple
    ),

    StatusLine = syntax_entry(palette.grey1, options.transparent_background_level == 2 and palette.none or palette.bg2),
    StatusLineTerm = syntax_entry(
      palette.grey1,
      options.transparent_background_level == 2 and palette.none or palette.bg1
    ),
    StatusLineNC = syntax_entry(
      options.transparent_background_level == 2 and palette.grey0 or palette.grey1,
      options.transparent_background_level == 2 and palette.none or palette.bg1
    ),
    StatusLineTermNC = syntax_entry(
      options.transparent_background_level == 2 and palette.grey0 or palette.grey1,
      options.transparent_background_level == 2 and palette.none or palette.bg0
    ),
    TabLine = syntax_entry(palette.grey2, palette.bg3),
    TabLineFill = syntax_entry(
      palette.grey1,
      options.transparent_background_level == 2 and palette.none or palette.bg1
    ),
    TabLineSel = syntax_entry(palette.bg0, palette.statusline1),
    VertSplit = syntax_entry(palette.bg4, (options.dim_inactive_windows and palette.bg_dim) or palette.none),
    WinSeparator = { link = "VertSplit" },

    Visual = syntax_entry(palette.none, palette.bg_visual),
    VisualNOS = syntax_entry(palette.none, palette.bg_visual),
    QuickFixLine = syntax_entry(palette.purple, palette.none, { styles.bold }),
    Debug = syntax_entry(palette.orange, palette.none),
    debugPC = syntax_entry(palette.bg0, palette.green),
    debugBreakpoint = syntax_entry(palette.bg0, palette.red),
    ToolbarButton = syntax_entry(palette.bg0, palette.green),
    Substitute = syntax_entry(palette.bg0, palette.yellow),
    WinBarNC = { link = "Grey" },
    DiagnosticFloatingError = { link = "ErrorFloat" },
    DiagnosticFloatingWarn = { link = "WarningFloat" },
    DiagnosticFloatingInfo = { link = "InfoFloat" },
    DiagnosticFloatingHint = { link = "HintFloat" },
    DiagnosticError = { link = "ErrorText" },
    DiagnosticWarn = { link = "WarningText" },
    DiagnosticInfo = { link = "InfoText" },
    DiagnosticHint = { link = "HintText" },
    DiagnosticVirtualTextError = { link = "VirtualTextError" },
    DiagnosticVirtualTextWarn = { link = "VirtualTextWarning" },
    DiagnosticVirtualTextInfo = { link = "VirtualTextInfo" },
    DiagnosticVirtualTextHint = { link = "VirtualTextHint" },
    DiagnosticUnderlineError = { link = "ErrorText" },
    DiagnosticUnderlineWarn = { link = "WarningText" },
    DiagnosticUnderlineInfo = { link = "InfoText" },
    DiagnosticUnderlineHint = { link = "HintText" },
    DiagnosticSignError = { link = "RedSign" },
    DiagnosticSignWarn = { link = "YellowSign" },
    DiagnosticSignInfo = { link = "BlueSign" },
    DiagnosticSignHint = { link = "GreenSign" },

    -- LSP colours
    LspDiagnosticsFloatingError = { link = "DiagnosticFloatingError" },
    LspDiagnosticsFloatingWarning = { link = "DiagnosticFloatingWarn" },
    LspDiagnosticsFloatingInformation = { link = "DiagnosticFloatingInfo" },
    LspDiagnosticsFloatingHint = { link = "DiagnosticFloatingHint" },
    LspDiagnosticsDefaultError = { link = "DiagnosticError" },
    LspDiagnosticsDefaultWarning = { link = "DiagnosticWarn" },
    LspDiagnosticsDefaultInformation = { link = "DiagnosticInfo" },
    LspDiagnosticsDefaultHint = { link = "DiagnosticHint" },
    LspDiagnosticsVirtualTextError = { link = "DiagnosticVirtualTextError" },
    LspDiagnosticsVirtualTextWarning = { link = "DiagnosticVirtualTextWarn" },
    LspDiagnosticsVirtualTextInformation = { link = "DiagnosticVirtualTextInfo" },
    LspDiagnosticsVirtualTextHint = { link = "DiagnosticVirtualTextHint" },
    LspDiagnosticsUnderlineError = { link = "DiagnosticUnderlineError" },
    LspDiagnosticsUnderlineWarning = { link = "DiagnosticUnderlineWarn" },
    LspDiagnosticsUnderlineInformation = { link = "DiagnosticUnderlineInfo" },
    LspDiagnosticsUnderlineHint = { link = "DiagnosticUnderlineHint" },
    LspDiagnosticsSignError = { link = "DiagnosticSignError" },
    LspDiagnosticsSignWarning = { link = "DiagnosticSignWarn" },
    LspDiagnosticsSignInformation = { link = "DiagnosticSignInfo" },
    LspDiagnosticsSignHint = { link = "DiagnosticSignHint" },
    LspReferenceText = { link = "CurrentWord" },
    LspReferenceRead = { link = "CurrentWord" },
    LspReferenceWrite = { link = "CurrentWord" },
    LspCodeLens = { link = "VirtualTextInfo" },
    LspCodeLensSeparator = { link = "VirtualTextHint" },
    LspSignatureActiveParameter = { link = "Search" },
    TermCursor = { link = "Cursor" },
    healthError = { link = "Red" },
    healthSuccess = { link = "Green" },
    healthWarning = { link = "Yellow" },

    Boolean = syntax_entry(palette.purple, palette.none),
    Number = syntax_entry(palette.purple, palette.none),
    Float = syntax_entry(palette.purple, palette.none),

    PreProc = syntax_entry(palette.purple, palette.none, optional_italics),
    PreCondit = syntax_entry(palette.purple, palette.none, optional_italics),
    Include = syntax_entry(palette.purple, palette.none, optional_italics),
    Define = syntax_entry(palette.purple, palette.none, optional_italics),
    Conditional = syntax_entry(palette.red, palette.none, optional_italics),
    Repeat = syntax_entry(palette.red, palette.none, optional_italics),
    Keyword = syntax_entry(palette.red, palette.none, optional_italics),
    Typedef = syntax_entry(palette.red, palette.none, optional_italics),
    Exception = syntax_entry(palette.red, palette.none, optional_italics),
    Statement = syntax_entry(palette.red, palette.none, optional_italics),

    Error = syntax_entry(palette.red, palette.none),
    StorageClass = syntax_entry(palette.orange, palette.none),
    Tag = syntax_entry(palette.orange, palette.none),
    Label = syntax_entry(palette.orange, palette.none),
    Structure = syntax_entry(palette.orange, palette.none),
    Operator = syntax_entry(palette.orange, palette.none),
    Title = syntax_entry(palette.orange, palette.none, { styles.bold }),
    Special = syntax_entry(palette.yellow, palette.none),
    SpecialChar = syntax_entry(palette.yellow, palette.none),
    Type = syntax_entry(palette.yellow, palette.none),
    Function = syntax_entry(palette.green, palette.none),
    String = syntax_entry(palette.green, palette.none),
    Character = syntax_entry(palette.green, palette.none),
    Constant = syntax_entry(palette.aqua, palette.none),
    Macro = syntax_entry(palette.aqua, palette.none),
    Identifier = syntax_entry(palette.blue, palette.none),

    Comment = syntax_entry(palette.grey1, palette.none, comment_italics),
    SpecialComment = syntax_entry(palette.grey1, palette.none, comment_italics),
    Todo = syntax_entry(palette.purple, palette.none, comment_italics),

    Delimiter = syntax_entry(palette.fg, palette.none),
    Ignore = syntax_entry(palette.grey1, palette.none),
    Underlined = syntax_entry(palette.none, palette.none, { styles.underline }),

    -- Predefined highlight groups
    Fg = syntax_entry(palette.fg, palette.none),
    Grey = syntax_entry(palette.grey1, palette.none),
    Red = syntax_entry(palette.red, palette.none),
    Orange = syntax_entry(palette.orange, palette.none),
    Yellow = syntax_entry(palette.yellow, palette.none),
    Green = syntax_entry(palette.green, palette.none),
    Aqua = syntax_entry(palette.aqua, palette.none),
    Blue = syntax_entry(palette.blue, palette.none),
    Purple = syntax_entry(palette.purple, palette.none),

    RedItalic = syntax_entry(palette.red, palette.none, optional_italics),
    OrangeItalic = syntax_entry(palette.orange, palette.none, optional_italics),
    YellowItalic = syntax_entry(palette.yellow, palette.none, optional_italics),
    GreenItalic = syntax_entry(palette.green, palette.none, optional_italics),
    AquaItalic = syntax_entry(palette.aqua, palette.none, optional_italics),
    BlueItalic = syntax_entry(palette.blue, palette.none, optional_italics),
    PurpleItalic = syntax_entry(palette.purple, palette.none, optional_italics),

    RedBold = syntax_entry(palette.red, palette.none, { styles.bold }),
    OrangeBold = syntax_entry(palette.orange, palette.none, { styles.bold }),
    YellowBold = syntax_entry(palette.yellow, palette.none, { styles.bold }),
    GreenBold = syntax_entry(palette.green, palette.none, { styles.bold }),
    AquaBold = syntax_entry(palette.aqua, palette.none, { styles.bold }),
    BlueBold = syntax_entry(palette.blue, palette.none, { styles.bold }),
    PurpleBold = syntax_entry(palette.purple, palette.none, { styles.bold }),

    RedSign = syntax_entry(palette.red, set_signs_background_colour(palette.bg1)),
    OrangeSign = syntax_entry(palette.orange, set_signs_background_colour(palette.bg1)),
    YellowSign = syntax_entry(palette.yellow, set_signs_background_colour(palette.bg1)),
    GreenSign = syntax_entry(palette.green, set_signs_background_colour(palette.bg1)),
    AquaSign = syntax_entry(palette.aqua, set_signs_background_colour(palette.bg1)),
    BlueSign = syntax_entry(palette.blue, set_signs_background_colour(palette.bg1)),
    PurpleSign = syntax_entry(palette.purple, set_signs_background_colour(palette.bg1)),

    -- Configuration based on `diagnostic_text_highlight` option
    ErrorText = syntax_entry(
      palette.none,
      options.diagnostic_text_highlight and palette.bg_red or palette.none,
      { styles.undercurl },
      palette.red
    ),
    WarningText = syntax_entry(
      palette.none,
      options.diagnostic_text_highlight and palette.bg_yellow or palette.none,
      { styles.undercurl },
      palette.yellow
    ),
    InfoText = syntax_entry(
      palette.none,
      options.diagnostic_text_highlight and palette.bg_blue or palette.none,
      { styles.undercurl },
      palette.blue
    ),
    HintText = syntax_entry(
      palette.none,
      options.diagnostic_text_highlight and palette.bg_green or palette.none,
      { styles.undercurl },
      palette.green
    ),

    ErrorLine = options.diagnostic_line_highlight and syntax_entry(palette.none, palette.bg_red) or {},
    WarningLine = options.diagnostic_line_highlight and syntax_entry(palette.none, palette.bg_yellow) or {},
    InfoLine = options.diagnostic_line_highlight and syntax_entry(palette.none, palette.bg_blue) or {},
    HintLine = options.diagnostic_line_highlight and syntax_entry(palette.none, palette.bg_green) or {},

    -- Configuration based on `diagnostic_virtual_text` option
    VirtualTextWarning = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Yellow" },
    VirtualTextError = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Red" },
    VirtualTextInfo = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Blue" },
    VirtualTextHint = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Green" },

    -- Diagnostic text inherits the background of the floating window, which is Neovim's default.
    ErrorFloat = syntax_entry(palette.red, palette.none),
    WarningFloat = syntax_entry(palette.yellow, palette.none),
    InfoFloat = syntax_entry(palette.blue, palette.none),
    HintFloat = syntax_entry(palette.green, palette.none),
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
    helpNote = syntax_entry(palette.purple, palette.none, { styles.bold }),
    helpHeadline = syntax_entry(palette.red, palette.none, { styles.bold }),
    helpHeader = syntax_entry(palette.orange, palette.none, { styles.bold }),
    helpURL = syntax_entry(palette.green, palette.none, { styles.underline }),
    helpHyperTextEntry = syntax_entry(palette.yellow, palette.none, { styles.bold }),
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
    TSNote = syntax_entry(palette.bg0, palette.blue, { styles.bold }),
    TSWarning = syntax_entry(palette.bg0, palette.yellow, { styles.bold }),
    TSDanger = syntax_entry(palette.bg0, palette.red, { styles.bold }),
    TSAnnotation = { link = "Purple" },
    TSAttribute = { link = "Purple" },
    TSBoolean = { link = "Purple" },
    TSCharacter = { link = "Aqua" },
    TSCharacterSpecial = { link = "SpecialChar" },
    TSComment = { link = "Comment" },
    TSConditional = { link = "Red" },
    TSConstBuiltin = { link = "PurpleItalic" },
    TSConstMacro = { link = "PurpleItalic" },
    TSConstant = { link = "Constant" },
    TSConstructor = { link = "Green" },
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
    TSFunction = { link = "Green" },
    TSFunctionCall = { link = "Green" },
    TSInclude = { link = "Red" },
    TSKeyword = { link = "Red" },
    TSKeywordFunction = { link = "Red" },
    TSKeywordOperator = { link = "Orange" },
    TSKeywordReturn = { link = "Red" },
    TSLabel = { link = "Orange" },
    TSLiteral = { link = "String" },
    TSMath = { link = "Blue" },
    TSMethod = { link = "Green" },
    TSMethodCall = { link = "Green" },
    TSModuleInfoGood = { link = "Green" },
    TSModuleInfoBad = { link = "Red" },
    TSNamespace = { link = "YellowItalic" },
    TSNone = { link = "Fg" },
    TSNumber = { link = "Purple" },
    TSOperator = { link = "Orange" },
    TSParameter = { link = "Fg" },
    TSParameterReference = { link = "Fg" },
    TSPreProc = { link = "PreProc" },
    TSProperty = { link = "Blue" },
    TSPunctBracket = { link = "Fg" },
    TSPunctDelimiter = { link = "Grey" },
    TSPunctSpecial = { link = "Blue" },
    TSRepeat = { link = "Red" },
    TSStorageClass = { link = "Orange" },
    TSStorageClassLifetime = { link = "Orange" },
    TSString = { link = "Aqua" },
    TSStringEscape = { link = "Green" },
    TSStringRegex = { link = "Green" },
    TSStringSpecial = { link = "SpecialChar" },
    TSSymbol = { link = "Purple" },
    TSTag = { link = "Orange" },
    TSTagAttribute = { link = "Green" },
    TSTagDelimiter = { link = "Green" },
    TSText = { link = "Green" },
    TSTextReference = { link = "Constant" },
    TSTitle = { link = "Title" },
    TSTodo = { link = "Todo" },
    TSType = { link = "YellowItalic" },
    TSTypeBuiltin = { link = "YellowItalic" },
    TSTypeDefinition = { link = "YellowItalic" },
    TSTypeQualifier = { link = "Orange" },
    TSURI = { link = "markdownUrl" },
    TSVariable = { link = "Fg" },
    TSVariableBuiltin = { link = "PurpleItalic" },

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
    ["@conditional"] = { link = "TSConditional" },
    ["@conceal"] = { link = "Grey" },
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
    ["@error"] = { link = "TSError" },
    ["@exception"] = { link = "TSException" },
    ["@field"] = { link = "TSField" },
    ["@field.yaml"] = { link = "yamlTSField" },
    ["@float"] = { link = "TSFloat" },
    ["@function"] = { link = "TSFunction" },
    ["@function.builtin"] = { link = "TSFuncBuiltin" },
    ["@function.call"] = { link = "TSFunctionCall" },
    ["@function.macro"] = { link = "TSFuncMacro" },
    ["@include"] = { link = "TSInclude" },
    ["@include.go"] = { link = "goTSInclude" },
    ["@include.javascript"] = { link = "javascriptTSInclude" },
    ["@include.typescript"] = { link = "typescriptTSInclude" },
    ["@keyword"] = { link = "TSKeyword" },
    ["@keyword.function"] = { link = "TSKeywordFunction" },
    ["@keyword.operator"] = { link = "TSKeywordOperator" },
    ["@keyword.return"] = { link = "TSKeywordReturn" },
    ["@label"] = { link = "TSLabel" },
    ["@label.json"] = { link = "jsonTSLabel" },
    ["@math"] = { link = "TSMath" },
    ["@method"] = { link = "TSMethod" },
    ["@method.call"] = { link = "TSMethodCall" },
    ["@namespace"] = { link = "TSNamespace" },
    ["@namespace.go"] = { link = "goTSNamespace" },
    ["@none"] = { link = "TSNone" },
    ["@number"] = { link = "TSNumber" },
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
    ["@repeat"] = { link = "TSRepeat" },
    ["@storageclass"] = { link = "TSStorageClass" },
    ["@storageclass.lifetime"] = { link = "TSStorageClassLifetime" },
    ["@strike"] = { link = "TSStrike" },
    ["@string"] = { link = "TSString" },
    ["@string.escape"] = { link = "TSStringEscape" },
    ["@string.escape.yaml"] = { link = "yamlTSStringEscape" },
    ["@string.json"] = { link = "jsonTSString" },
    ["@string.regex"] = { link = "TSStringRegex" },
    ["@string.special"] = { link = "TSStringSpecial" },
    ["@string.toml"] = { link = "tomlTSString" },
    ["@string.yaml"] = { link = "yamlTSString" },
    ["@symbol"] = { link = "TSSymbol" },
    ["@tag"] = { link = "TSTag" },
    ["@tag.delimiter"] = { link = "TSTagDelimiter" },
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
    ["@text.strong"] = { link = "TSStrong" },
    ["@text.title"] = { link = "TSTitle" },
    ["@text.todo"] = { link = "TSTodo" },
    ["@text.todo.checked"] = { link = "Green" },
    ["@text.todo.unchecked"] = { link = "Ignore" },
    ["@text.underline"] = { link = "TSUnderline" },
    ["@text.strike"] = { link = "TSStrike" },
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

    -- LSP Semantic token highlights
    ["@lsp.type.class"] = { link = "TSType" },
    ["@lsp.type.comment"] = { link = "TSComment" },
    ["@lsp.type.decorator"] = { link = "TSFunction" },
    ["@lsp.type.function"] = { link = "TSFunction" },
    ["@lsp.type.enum"] = { link = "TSType" },
    ["@lsp.type.enumMember"] = { link = "TSProperty" },
    ["@lsp.type.interface"] = { link = "TSType" },
    ["@lsp.type.keyword"] = { link = "TSKeyword" },
    ["@lsp.type.macro"] = { link = "TSConstMacro" },
    ["@lsp.type.method"] = { link = "TSMethod" },
    ["@lsp.type.modifier"] = { link = "TSTypeQualifier" },
    ["@lsp.type.namespace"] = { link = "TSNamespace" },
    ["@lsp.type.namespace.go"] = { link = "goTSNamespace" },
    ["@lsp.type.number"] = { link = "TSNumber" },
    ["@lsp.type.operator"] = { link = "TSOperator" },
    ["@lsp.type.parameter"] = { link = "TSParameter" },
    ["@lsp.type.property"] = { link = "TSProperty" },
    ["@lsp.type.regexp"] = { link = "TSStringRegex" },
    ["@lsp.type.string"] = { link = "TSString" },
    ["@lsp.type.struct"] = { link = "TSType" },
    ["@lsp.type.type"] = { link = "TSType" },
    ["@lsp.type.typeParameter"] = { link = "TSTypeDefinition" },
    ["@lsp.type.variable"] = { link = "TSVariable" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.operator.injected"] = { link = "@operator" },
    ["@lsp.typemod.string.injected"] = { link = "@string" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.defaultLibrary.go"] = { link = "goTSConstBuiltin" },
    ["@lsp.typemod.variable.defaultLibrary.javascript"] = { link = "TSConstBuiltin" },
    ["@lsp.typemod.variable.defaultLibrary.javascriptreact"] = { link = "TSConstBuiltin" },
    ["@lsp.typemod.variable.defaultLibrary.typescript"] = { link = "TSConstBuiltin" },
    ["@lsp.typemod.variable.defaultLibrary.typescriptreact"] = { link = "TSConstBuiltin" },
    ["@lsp.typemod.variable.injected"] = { link = "@variable" },

    -- p00f/ts-rainbow
    rainbowcol1 = syntax_entry(palette.red, palette.none),
    rainbowcol2 = syntax_entry(palette.orange, palette.none),
    rainbowcol3 = syntax_entry(palette.yellow, palette.none),
    rainbowcol4 = syntax_entry(palette.green, palette.none),
    rainbowcol5 = syntax_entry(palette.aqua, palette.none),
    rainbowcol6 = syntax_entry(palette.blue, palette.none),
    rainbowcol7 = syntax_entry(palette.purple, palette.none),

    -- HiPhish/nvim-ts-rainbow2
    TSRainbowRed = { link = "rainbowcol1" },
    TSRainbowOrange = { link = "rainbowcol2" },
    TSRainbowYellow = { link = "rainbowcol3" },
    TSRainbowGreen = { link = "rainbowcol4" },
    TSRainbowCyan = { link = "rainbowcol5" },
    TSRainbowBlue = { link = "rainbowcol6" },
    TSRainbowViolet = { link = "rainbowcol7" },

    -- HiPhish/rainbow-delimiters
    RainbowDelimiterRed = { link = "rainbowcol1" },
    RainbowDelimiterOrange = { link = "rainbowcol2" },
    RainbowDelimiterYellow = { link = "rainbowcol3" },
    RainbowDelimiterGreen = { link = "rainbowcol4" },
    RainbowDelimiterCyan = { link = "rainbowcol5" },
    RainbowDelimiterBlue = { link = "rainbowcol6" },
    RainbowDelimiterViolet = { link = "rainbowcol7" },

    -- Diff
    diffAdded = { link = "Green" },
    diffRemoved = { link = "Red" },
    diffChanged = { link = "Blue" },
    diffOldFile = { link = "Yellow" },
    diffNewFile = { link = "Orange" },
    diffFile = { link = "Aqua" },
    diffLine = { link = "Grey" },
    diffIndexLine = { link = "Purple" },

    -- machakann/vim-highlightedyank
    HighlightedyankRegion = { link = "Visual" },

    -- Coc.nvim
    CocHoverRange = syntax_entry(palette.none, palette.none, { styles.bold, styles.underline }),
    CocSearch = syntax_entry(palette.green, palette.none, { styles.bold }),
    CocPumSearch = syntax_entry(palette.green, palette.none, { styles.bold }),
    CocMarkdownHeader = syntax_entry(palette.orange, palette.none, { styles.bold }),
    CocMarkdownLink = syntax_entry(palette.green, palette.none, { styles.underline }),
    CocMarkdownCode = { link = "Green" },
    CocPumShortcut = { link = "Grey" },
    CocPumVirtualText = { link = "Grey" },
    CocPumMenu = { link = "Pmenu" },
    CocMenuSel = { link = "PmenuSel" },
    CocDisabled = { link = "Grey" },
    CocSnippetVisual = { link = "DiffAdd" },
    CocInlayHint = { link = "LineNr" },
    CocNotificationProgress = { link = "Green" },
    CocNotificationButton = { link = "PmenuSel" },
    CocSemClass = { link = "TSType" },
    CocSemEnum = { link = "TSType" },
    CocSemInterface = { link = "TSType" },
    CocSemStruct = { link = "TSType" },
    CocSemTypeParameter = { link = "TSType" },
    CocSemVariable = { link = "TSVariable" },
    CocSemEnumMember = { link = "TSVariableBuiltin" },
    CocSemEvent = { link = "TSLabel" },
    CocSemModifier = { link = "TSOperator" },
    CocErrorFloat = { link = "ErrorFloat" },
    CocWarningFloat = { link = "WarningFloat" },
    CocInfoFloat = { link = "InfoFloat" },
    CocHintFloat = { link = "HintFloat" },
    CocFloatDividingLine = { link = "Grey" },
    CocErrorHighlight = { link = "ErrorText" },
    CocWarningHighlight = { link = "WarningText" },
    CocInfoHighlight = { link = "InfoText" },
    CocHintHighlight = { link = "HintText" },
    CocHighlightText = { link = "CurrentWord" },
    CocErrorSign = { link = "RedSign" },
    CocWarningSign = { link = "YellowSign" },
    CocInfoSign = { link = "BlueSign" },
    CocHintSign = { link = "GreenSign" },
    CocWarningVirtualText = { link = "VirtualTextWarning" },
    CocErrorVirtualText = { link = "VirtualTextError" },
    CocInfoVirtualText = { link = "VirtualTextInfo" },
    CocHintVirtualText = { link = "VirtualTextHint" },
    CocErrorLine = { link = "ErrorLine" },
    CocWarningLine = { link = "WarningLine" },
    CocInfoLine = { link = "InfoLine" },
    CocHintLine = { link = "HintLine" },
    CocCodeLens = { link = "Grey" },
    CocFadeOut = { link = "Grey" },
    CocStrikeThrough = { link = "Grey" },
    CocListMode = { link = "StatusLine" },
    CocListPath = { link = "StatusLine" },
    CocSelectedText = { link = "Orange" },
    CocListsLine = { link = "Fg" },
    CocListsDesc = { link = "Grey" },
    CocGitAddedSign = { link = "GreenSign" },
    CocGitChangeRemovedSign = { link = "PurpleSign" },
    CocGitChangedSign = { link = "BlueSign" },
    CocGitRemovedSign = { link = "RedSign" },
    CocGitTopRemovedSign = { link = "RedSign" },
    CocTreeOpenClose = { link = "Aqua" },
    CocTreeDescription = { link = "Grey" },
    CocSymbolFile = { link = "Green" },
    CocSymbolModule = { link = "Purple" },
    CocSymbolNamespace = { link = "Purple" },
    CocSymbolPackage = { link = "Purple" },
    CocSymbolClass = { link = "Red" },
    CocSymbolMethod = { link = "Green" },
    CocSymbolProperty = { link = "Blue" },
    CocSymbolField = { link = "Green" },
    CocSymbolConstructor = { link = "Green" },
    CocSymbolEnum = { link = "Yellow" },
    CocSymbolInterface = { link = "Yellow" },
    CocSymbolFunction = { link = "Green" },
    CocSymbolVariable = { link = "Blue" },
    CocSymbolConstant = { link = "Blue" },
    CocSymbolString = { link = "Aqua" },
    CocSymbolNumber = { link = "Aqua" },
    CocSymbolBoolean = { link = "Aqua" },
    CocSymbolArray = { link = "Aqua" },
    CocSymbolObject = { link = "Aqua" },
    CocSymbolKey = { link = "Red" },
    CocSymbolNull = { link = "Aqua" },
    CocSymbolEnumMember = { link = "Aqua" },
    CocSymbolStruct = { link = "Yellow" },
    CocSymbolEvent = { link = "Orange" },
    CocSymbolOperator = { link = "Orange" },
    CocSymbolTypeParameter = { link = "Yellow" },
    CocSymbolDefault = { link = "Aqua" },

    -- https://github.com/weirongxu/coc-explorer
    CocExplorerBufferRoot = { link = "Orange" },
    CocExplorerBufferExpandIcon = { link = "Aqua" },
    CocExplorerBufferBufnr = { link = "Purple" },
    CocExplorerBufferModified = { link = "Yellow" },
    CocExplorerBufferReadonly = { link = "Red" },
    CocExplorerBufferBufname = { link = "Grey" },
    CocExplorerBufferFullpath = { link = "Grey" },
    CocExplorerFileRoot = { link = "Orange" },
    CocExplorerFileRootName = { link = "Green" },
    CocExplorerFileExpandIcon = { link = "Aqua" },
    CocExplorerFileFullpath = { link = "Grey" },
    CocExplorerFileDirectory = { link = "Green" },
    CocExplorerFileGitStaged = { link = "Purple" },
    CocExplorerFileGitUnstaged = { link = "Yellow" },
    CocExplorerFileGitRootStaged = { link = "Purple" },
    CocExplorerFileGitRootUnstaged = { link = "Yellow" },
    CocExplorerGitPathChange = { link = "Fg" },
    CocExplorerGitContentChange = { link = "Fg" },
    CocExplorerGitRenamed = { link = "Purple" },
    CocExplorerGitCopied = { link = "Fg" },
    CocExplorerGitAdded = { link = "Green" },
    CocExplorerGitUntracked = { link = "Blue" },
    CocExplorerGitUnmodified = { link = "Fg" },
    CocExplorerGitUnmerged = { link = "Orange" },
    CocExplorerGitMixed = { link = "Aqua" },
    CocExplorerGitModified = { link = "Yellow" },
    CocExplorerGitDeleted = { link = "Red" },
    CocExplorerGitIgnored = { link = "Grey" },
    CocExplorerFileSize = { link = "Blue" },
    CocExplorerTimeAccessed = { link = "Aqua" },
    CocExplorerTimeCreated = { link = "Aqua" },
    CocExplorerTimeModified = { link = "Aqua" },
    CocExplorerIndentLine = { link = "Conceal" },
    CocExplorerHelpDescription = { link = "Grey" },
    CocExplorerHelpHint = { link = "Grey" },
    CocExplorerDiagnosticError = { link = "Red" },
    CocExplorerDiagnosticWarning = { link = "Yellow" },
    CocExplorerFileHidden = { link = "Grey" },

    -- prabirshrestha/vim-lsp
    LspErrorVirtual = { link = "VirtualTextError" },
    LspWarningVirtual = { link = "VirtualTextWarning" },
    LspInformationVirtual = { link = "VirtualTextInfo" },
    LspHintVirtual = { link = "VirtualTextHint" },
    LspErrorHighlight = { link = "ErrorText" },
    LspWarningHighlight = { link = "WarningText" },
    LspInformationHighlight = { link = "InfoText" },
    LspHintHighlight = { link = "HintText" },
    lspReference = { link = "CurrentWord" },
    lspInlayHintsType = { link = "LineNr" },
    lspInlayHintsParameter = { link = "LineNr" },
    LspSemanticType = { link = "TSType" },
    LspSemanticClass = { link = "TSType" },
    LspSemanticEnum = { link = "TSType" },
    LspSemanticInterface = { link = "TSType" },
    LspSemanticStruct = { link = "TSType" },
    LspSemanticTypeParameter = { link = "TSType" },
    LspSemanticParameter = { link = "TSParameter" },
    LspSemanticVariable = { link = "TSVariable" },
    LspSemanticProperty = { link = "TSProperty" },
    LspSemanticEnumMember = { link = "TSVariableBuiltin" },
    LspSemanticEvents = { link = "TSLabel" },
    LspSemanticFunction = { link = "TSFunction" },
    LspSemanticMethod = { link = "TSMethod" },
    LspSemanticKeyword = { link = "TSKeyword" },
    LspSemanticModifier = { link = "TSOperator" },
    LspSemanticComment = { link = "TSComment" },
    LspSemanticString = { link = "TSString" },
    LspSemanticNumber = { link = "TSNumber" },
    LspSemanticRegexp = { link = "TSStringRegex" },
    LspSemanticOperator = { link = "TSOperator" },

    -- ycm-core/YouCompleteMe
    YcmErrorSign = { link = "RedSign" },
    YcmWarningSign = { link = "YellowSign" },
    YcmErrorLine = { link = "ErrorLine" },
    YcmWarningLine = { link = "WarningLine" },
    YcmErrorSection = { link = "ErrorText" },
    YcmWarningSection = { link = "WarningText" },
    YcmInlayHint = { link = "LineNr" },

    -- dense-analysis/ale
    ALEError = { link = "ErrorText" },
    ALEWarning = { link = "WarningText" },
    ALEInfo = { link = "InfoText" },
    ALEErrorSign = { link = "RedSign" },
    ALEWarningSign = { link = "YellowSign" },
    ALEInfoSign = { link = "BlueSign" },
    ALEErrorLine = { link = "ErrorLine" },
    ALEWarningLine = { link = "WarningLine" },
    ALEInfoLine = { link = "InfoLine" },
    ALEVirtualTextError = { link = "VirtualTextError" },
    ALEVirtualTextWarning = { link = "VirtualTextWarning" },
    ALEVirtualTextInfo = { link = "VirtualTextInfo" },
    ALEVirtualTextStyleError = { link = "VirtualTextHint" },
    ALEVirtualTextStyleWarning = { link = "VirtualTextHint" },

    -- neomake/neomake
    NeomakeError = { link = "ErrorText" },
    NeomakeWarning = { link = "WarningText" },
    NeomakeInfo = { link = "InfoText" },
    NeomakeMessage = { link = "HintText" },
    NeomakeErrorSign = { link = "RedSign" },
    NeomakeWarningSign = { link = "YellowSign" },
    NeomakeInfoSign = { link = "BlueSign" },
    NeomakeMessageSign = { link = "AquaSign" },
    NeomakeVirtualtextError = { link = "VirtualTextError" },
    NeomakeVirtualtextWarning = { link = "VirtualTextWarning" },
    NeomakeVirtualtextInfo = { link = "VirtualTextInfo" },
    NeomakeVirtualtextMessag = { link = "VirtualTextHint" },

    -- vim-syntastic/syntastic
    SyntasticError = { link = "ErrorText" },
    SyntasticWarning = { link = "WarningText" },
    SyntasticErrorSign = { link = "RedSign" },
    SyntasticWarningSign = { link = "YellowSign" },
    SyntasticErrorLine = { link = "ErrorLine" },
    SyntasticWarningLine = { link = "WarningLine" },

    -- liuchengxu/vim-clap
    ClapSelected = syntax_entry(palette.red, palette.none, { styles.bold }),
    ClapCurrentSelection = syntax_entry(palette.none, palette.bg1, { styles.bold }),
    ClapSpinner = syntax_entry(palette.orange, palette.bg2, { styles.bold }),
    ClapBlines = syntax_entry(palette.fg, palette.none),
    ClapProviderId = syntax_entry(palette.fg, palette.none, { styles.bold }),
    ClapMatches1 = syntax_entry(palette.red, palette.none, { styles.bold }),
    ClapMatches2 = syntax_entry(palette.orange, palette.none, { styles.bold }),
    ClapMatches3 = syntax_entry(palette.yellow, palette.none, { styles.bold }),
    ClapMatches4 = syntax_entry(palette.aqua, palette.none, { styles.bold }),
    ClapMatches5 = syntax_entry(palette.blue, palette.none, { styles.bold }),
    ClapMatches6 = syntax_entry(palette.purple, palette.none, { styles.bold }),
    ClapFuzzyMatches = syntax_entry(palette.green, palette.none, { styles.bold }),
    ClapNoMatchesFound = syntax_entry(palette.red, palette.none, { styles.bold }),
    ClapInput = { link = "Pmenu" },
    ClapDisplay = { link = "Pmenu" },
    ClapPreview = { link = "Pmenu" },
    ClapFuzzyMatches1 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches2 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches3 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches4 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches5 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches6 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches7 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches8 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches9 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches10 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches11 = { link = "ClapFuzzyMatches" },
    ClapFuzzyMatches12 = { link = "ClapFuzzyMatches" },
    ClapBlinesLineNr = { link = "Grey" },
    ClapProviderColon = { link = "ClapBlines" },
    ClapProviderAbout = { link = "ClapBlines" },
    ClapFile = { link = "Fg" },
    ClapSearchText = { link = "ClapFuzzyMatches" },

    -- Shougo/denite.nvim
    deniteMatchedChar = syntax_entry(palette.green, palette.none, { styles.bold }),
    deniteMatchedRange = syntax_entry(palette.green, palette.none, { styles.bold, styles.underline }),
    deniteInput = syntax_entry(palette.green, palette.bg3, { styles.bold }),
    deniteStatusLineNumber = syntax_entry(palette.purple, palette.bg3),
    deniteStatusLinePath = syntax_entry(palette.fg, palette.bg3),
    deniteSelectedLin = { link = "Green" },

    -- kien/ctrlp.vim
    CtrlPMatch = syntax_entry(palette.green, palette.none, { styles.bold }),
    CtrlPPrtBase = syntax_entry(palette.bg3, palette.none),
    CtrlPLinePre = syntax_entry(palette.bg3, palette.none),
    CtrlPMode1 = syntax_entry(palette.blue, palette.bg3, { styles.bold }),
    CtrlPMode2 = syntax_entry(palette.bg0, palette.blue, { styles.bold }),
    CtrlPStats = syntax_entry(palette.grey1, palette.bg3, { styles.bold }),
    CtrlPNoEntries = { link = "Red" },
    CtrlPPrtCursor = { link = "Blue" },

    -- airblade/vim-gitgutter
    GitGutterAdd = { link = "GreenSign" },
    GitGutterChange = { link = "BlueSign" },
    GitGutterDelete = { link = "RedSign" },
    GitGutterChangeDelete = { link = "PurpleSign" },
    GitGutterAddLine = { link = "DiffAdd" },
    GitGutterChangeLine = { link = "DiffChange" },
    GitGutterDeleteLine = { link = "DiffDelete" },
    GitGutterChangeDeleteLine = { link = "DiffChange" },
    GitGutterAddLineNr = { link = "Green" },
    GitGutterChangeLineNr = { link = "Blue" },
    GitGutterDeleteLineNr = { link = "Red" },
    GitGutterChangeDeleteLineNr = { link = "Purple" },

    -- mhinz/vim-signify
    SignifySignAdd = { link = "GreenSign" },
    SignifySignChange = { link = "BlueSign" },
    SignifySignDelete = { link = "RedSign" },
    SignifySignChangeDelete = { link = "PurpleSign" },
    SignifyLineAdd = { link = "DiffAdd" },
    SignifyLineChange = { link = "DiffChange" },
    SignifyLineChangeDelete = { link = "DiffChange" },
    SignifyLineDelete = { link = "DiffDelete" },

    -- andymass/vim-matchup
    MatchParenCur = syntax_entry(palette.none, palette.none, { styles.bold }),
    MatchWord = syntax_entry(palette.none, palette.none, { styles.underline }),
    MatchWordCur = syntax_entry(palette.none, palette.none, { styles.underline }),

    -- easymotion/vim-easymotion
    EasyMotionTarget = { link = "Search" },
    EasyMotionShade = { link = "Grey" },

    -- justinmk/vim-sneak
    SneakLabelMask = syntax_entry(palette.orange, palette.orange),
    Sneak = { link = "Search" },
    SneakLabel = { link = "Search" },
    SneakScope = { link = "DiffText" },

    -- rhysd/clever-f.vim
    CleverFDefaultLabel = { link = "Search" },

    -- dominikduda/vim_current_word
    CurrentWordTwins = { link = "CurrentWord" },

    -- RRethy/vim-illuminate
    illuminatedWord = { link = "CurrentWord" },
    IlluminatedWordText = { link = "CurrentWord" },
    IlluminatedWordRead = { link = "CurrentWord" },
    IlluminatedWordWrite = { link = "CurrentWord" },

    -- itchyny/vim-cursorword
    CursorWord0 = { link = "CurrentWord" },
    CursorWord1 = { link = "CurrentWord" },

    -- thiagoalessio/rainbow_levels.vim
    RainbowLevel0 = { link = "Red" },
    RainbowLevel1 = { link = "Orange" },
    RainbowLevel2 = { link = "Yellow" },
    RainbowLevel3 = { link = "Green" },
    RainbowLevel4 = { link = "Aqua" },
    RainbowLevel5 = { link = "Blue" },
    RainbowLevel6 = { link = "Purple" },
    RainbowLevel7 = { link = "Yellow" },
    RainbowLevel8 = { link = "Green" },

    -- kshenoy/vim-signature
    SignatureMarkText = { link = "BlueSign" },
    SignatureMarkerText = { link = "PurpleSign" },

    -- ap/vim-buftabline
    BufTabLineCurrent = { link = "TabLineSel" },
    BufTabLineActive = { link = "TabLine" },
    BufTabLineHidden = { link = "TabLineFill" },
    BufTabLineFill = { link = "TabLineFill" },

    -- folke/which-key.nvim
    WhichKey = { link = "Red" },
    WhichKeyDesc = { link = "Blue" },
    WhichKeyFloat = syntax_entry(palette.none, palette.bg1),
    WhichKeyGroup = { link = "Yellow" },
    WhichKeySeparator = { link = "Green" },
    WhichKeyValue = syntax_entry(palette.fg, palette.none),

    -- unblevable/quick-scope
    QuickScopePrimary = syntax_entry(palette.aqua, palette.none, { styles.underline }),
    QuickScopeSecondary = syntax_entry(palette.blue, palette.none, { styles.underline }),

    -- APZelos/blamer.nvim
    Blamer = { link = "Grey" },

    -- cohama/agit.vim
    agitTree = { link = "Grey" },
    agitDate = { link = "Green" },
    agitRemote = { link = "Red" },
    agitHead = { link = "Orange" },
    agitRef = { link = "Aqua" },
    agitTag = { link = "Orange" },
    agitStatFile = { link = "Blue" },
    agitStatRemoved = { link = "Red" },
    agitStatAdded = { link = "Green" },
    agitStatMessage = { link = "Orange" },
    agitDiffRemove = { link = "Red" },
    agitDiffAdd = { link = "Green" },
    agitDiffHeader = { link = "Purple" },

    -- voldikss/vim-floaterm
    FloatermBorder = { link = "Grey" },

    -- MattesGroeger/vim-bookmarks
    BookmarkSign = { link = "BlueSign" },
    BookmarkAnnotationSign = { link = "GreenSign" },
    BookmarkLine = { link = "DiffChange" },
    BookmarkAnnotationLine = { link = "DiffAdd" },

    -- hrsh7th/nvim-cmp
    CmpItemAbbrMatch = syntax_entry(palette.green, palette.none, { styles.bold }),
    CmpItemAbbrMatchFuzzy = syntax_entry(palette.green, palette.none, { styles.bold }),
    CmpItemAbbr = { link = "Fg" },
    CmpItemAbbrDeprecated = { link = "Grey" },
    CmpItemMenu = { link = "Fg" },
    CmpItemKind = { link = "Yellow" },
    CmpItemKindClass = { link = "Yellow" },
    CmpItemKindColor = { link = "Aqua" },
    CmpItemKindConstant = { link = "Blue" },
    CmpItemKindConstructor = { link = "Green" },
    CmpItemKindEnum = { link = "Yellow" },
    CmpItemKindEnumMember = { link = "Purple" },
    CmpItemKindEvent = { link = "Orange" },
    CmpItemKindField = { link = "Green" },
    CmpItemKindFile = { link = "Aqua" },
    CmpItemKindFolder = { link = "Aqua" },
    CmpItemKindFunction = { link = "Green" },
    CmpItemKindInterface = { link = "Yellow" },
    CmpItemKindKeyword = { link = "Red" },
    CmpItemKindMethod = { link = "Green" },
    CmpItemKindModule = { link = "Yellow" },
    CmpItemKindOperator = { link = "Orange" },
    CmpItemKindProperty = { link = "Blue" },
    CmpItemKindReference = { link = "Aqua" },
    CmpItemKindSnippet = { link = "Aqua" },
    CmpItemKindStruct = { link = "Yellow" },
    CmpItemKindText = { link = "Fg" },
    CmpItemKindTypeParameter = { link = "Yellow" },
    CmpItemKindUnit = { link = "Purple" },
    CmpItemKindValue = { link = "Purple" },
    CmpItemKindVariable = { link = "Blue" },

    -- folke/trouble.nvim
    TroubleText = { link = "Fg" },
    TroubleSource = { link = "Grey" },
    TroubleCode = { link = "Grey" },

    -- nvim-telescope/telescope.nvim
    TelescopeMatching = syntax_entry(palette.green, palette.none, { styles.bold }),
    TelescopeBorder = { link = "Grey" },
    TelescopePromptPrefix = { link = "Orange" },
    TelescopeSelection = { link = "DiffAdd" },

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

    -- phaazon/hop.nvim
    HopNextKey = syntax_entry(palette.orange, palette.none, { styles.bold }),
    HopNextKey1 = syntax_entry(palette.green, palette.none, { styles.bold }),
    HopNextKey2 = { link = "Green" },
    HopUnmatched = { link = "Grey" },

    -- folke/flash.nvim
    FlashBackdrop = syntax_entry(palette.grey1, palette.none),
    FlashLabel = syntax_entry(palette.purple, palette.none, { styles.bold, styles.italic }),

    -- ggandor/leap.nvim
    LeapMatch = syntax_entry(palette.fg, palette.purple, { styles.bold }),
    LeapLabelPrimary = syntax_entry(palette.purple, palette.none, { styles.bold }),
    LeapLabelSecondary = syntax_entry(palette.green, palette.none, { styles.bold }),
    LeapBackdrop = syntax_entry(palette.grey1, palette.none),

    -- lukas-reineke/indent-blankline.nvim
    IndentBlanklineContextChar = syntax_entry(palette.grey1, palette.none, { styles.nocombine }),
    IndentBlanklineContextStart = syntax_entry(palette.none, palette.bg2),
    IndentBlanklineChar = syntax_entry(palette.bg5, palette.none, { styles.nocombine }),
    IndentBlanklineSpaceChar = { link = "IndentBlanklineChar" },
    IndentBlanklineSpaceCharBlankline = { link = "IndentBlanklineChar" },

    -- romgrk/barbar.nvim
    BufferCurrent = syntax_entry(palette.fg, palette.bg0),
    BufferCurrentIndex = syntax_entry(palette.fg, palette.bg0),
    BufferCurrentMod = syntax_entry(palette.blue, palette.bg0),
    BufferCurrentSign = syntax_entry(palette.statusline1, palette.bg0),
    BufferCurrentTarget = syntax_entry(palette.red, palette.bg0, { styles.bold }),
    BufferVisible = syntax_entry(palette.fg, palette.bg_dim),
    BufferVisibleIndex = syntax_entry(palette.fg, palette.bg_dim),
    BufferVisibleMod = syntax_entry(palette.blue, palette.bg_dim),
    BufferVisibleSign = syntax_entry(palette.statusline1, palette.bg_dim),
    BufferVisibleTarget = syntax_entry(palette.yellow, palette.bg_dim, { styles.bold }),
    BufferInactive = syntax_entry(palette.grey1, palette.bg_dim),
    BufferInactiveIndex = syntax_entry(palette.grey1, palette.bg_dim),
    BufferInactiveMod = syntax_entry(palette.grey1, palette.bg_dim),
    BufferInactiveSign = syntax_entry(palette.grey0, palette.bg_dim),
    BufferInactiveTarget = syntax_entry(palette.yellow, palette.bg_dim, { styles.bold }),
    BufferTabpages = syntax_entry(palette.grey1, palette.bg_dim, { styles.bold }),
    BufferTabpageFill = syntax_entry(palette.bg_dim, palette.bg_dim),

    -- SmiteshP/nvim-navic
    NavicIconsFile = syntax_entry(palette.fg, palette.none),
    NavicIconsModule = syntax_entry(palette.yellow, palette.none),
    NavicIconsNamespace = syntax_entry(palette.fg, palette.none),
    NavicIconsPackage = syntax_entry(palette.fg, palette.none),
    NavicIconsClass = syntax_entry(palette.orange, palette.none),
    NavicIconsMethod = syntax_entry(palette.blue, palette.none),
    NavicIconsProperty = syntax_entry(palette.green, palette.none),
    NavicIconsField = syntax_entry(palette.green, palette.none),
    NavicIconsConstructor = syntax_entry(palette.orange, palette.none),
    NavicIconsEnum = syntax_entry(palette.orange, palette.none),
    NavicIconsInterface = syntax_entry(palette.orange, palette.none),
    NavicIconsFunction = syntax_entry(palette.blue, palette.none),
    NavicIconsVariable = syntax_entry(palette.purple, palette.none),
    NavicIconsConstant = syntax_entry(palette.purple, palette.none),
    NavicIconsString = syntax_entry(palette.green, palette.none),
    NavicIconsNumber = syntax_entry(palette.orange, palette.none),
    NavicIconsBoolean = syntax_entry(palette.orange, palette.none),
    NavicIconsArray = syntax_entry(palette.orange, palette.none),
    NavicIconsObject = syntax_entry(palette.orange, palette.none),
    NavicIconsKey = syntax_entry(palette.purple, palette.none),
    NavicIconsKeyword = syntax_entry(palette.purple, palette.none),
    NavicIconsNull = syntax_entry(palette.orange, palette.none),
    NavicIconsEnumMember = syntax_entry(palette.green, palette.none),
    NavicIconsStruct = syntax_entry(palette.orange, palette.none),
    NavicIconsEvent = syntax_entry(palette.orange, palette.none),
    NavicIconsOperator = syntax_entry(palette.fg, palette.none),
    NavicIconsTypeParameter = syntax_entry(palette.green, palette.none),
    NavicText = syntax_entry(palette.fg, palette.none),
    NavicSeparator = syntax_entry(palette.fg, palette.none),

    -- rcarriga/nvim-notify
    NotifyBackground = syntax_entry(palette.fg, palette.bg0),
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
    DapUIModifiedValue = syntax_entry(palette.blue, palette.none, { styles.bold }),
    DapUIBreakpointsCurrentLine = syntax_entry(palette.blue, palette.none, { styles.bold }),
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

    -- glepnir/lspsaga.nvim
    CodeActionBorder = { link = "Purple" },
    DiagnosticBorder = { link = "Orange" },
    DiagnosticShowBorder = { link = "Orange" },
    DiagnosticSource = { link = "Orange" },
    HoverBorder = { link = "Green" },
    RenameBorder = { link = "Purple" },
    SagaBorder = { link = "Blue" },

    -- b0o/incline.nvim
    InclineNormalNC = syntax_entry(palette.grey1, palette.bg2),

    -- echasnovski/mini.nvim
    MiniIndentscopePrefix = syntax_entry(palette.none, palette.none, { styles.nocombine }),
    MiniJump2dSpot = syntax_entry(palette.orange, palette.none, { styles.bold, styles.nocombine }),
    MiniStarterCurrent = syntax_entry(palette.none, palette.none, { styles.nocombine }),
    MiniStatuslineDevinfo = syntax_entry(palette.grey1, palette.bg1),
    MiniStatuslineFileinfo = syntax_entry(palette.grey1, palette.bg1),
    MiniStatuslineModeCommand = syntax_entry(palette.bg0, palette.aqua, { styles.bold }),
    MiniStatuslineModeInsert = syntax_entry(palette.bg0, palette.statusline2, { styles.bold }),
    MiniStatuslineModeNormal = syntax_entry(palette.bg0, palette.statusline1, { styles.bold }),
    MiniStatuslineModeOther = syntax_entry(palette.bg0, palette.purple, { styles.bold }),
    MiniStatuslineModeReplace = syntax_entry(palette.bg0, palette.orange, { styles.bold }),
    MiniStatuslineModeVisual = syntax_entry(palette.bg0, palette.statusline3, { styles.bold }),
    MiniTablineCurrent = syntax_entry(palette.fg, palette.bg4),
    MiniTablineHidden = syntax_entry(palette.grey1, palette.bg2),
    MiniTablineModifiedCurrent = syntax_entry(palette.blue, palette.bg4),
    MiniTablineModifiedHidden = syntax_entry(palette.grey1, palette.bg2),
    MiniTablineModifiedVisible = syntax_entry(palette.blue, palette.bg2),
    MiniTablineTabpagesection = syntax_entry(palette.bg0, palette.statusline1, { styles.bold }),
    MiniTablineVisible = syntax_entry(palette.fg, palette.bg2),
    MiniTestEmphasis = syntax_entry(palette.none, palette.none, { styles.bold }),
    MiniTestFail = syntax_entry(palette.red, palette.none, { styles.bold }),
    MiniTestPass = syntax_entry(palette.green, palette.none, { styles.bold }),
    MiniTrailspace = syntax_entry(palette.none, palette.red),
    MiniStarterItemBullet = { link = "Grey" },
    MiniStarterItemPrefix = { link = "Yellow" },
    MiniStarterQuery = { link = "Blue" },
    MiniStatuslineFilename = { link = "Grey" },
    MiniStatuslineModeInactive = { link = "Grey" },
    MiniCompletionActiveParameter = { link = "LspSignatureActiveParameter" },
    MiniCursorword = { link = "CurrentWord" },
    MiniCursorwordCurrent = { link = "CurrentWord" },
    MiniIndentscopeSymbol = { link = "Grey" },
    MiniJump = { link = "Search" },
    MiniStarterFooter = { link = "Orange" },
    MiniStarterHeader = { link = "Yellow" },
    MiniStarterInactive = { link = "Comment" },
    MiniStarterItem = { link = "Normal" },
    MiniStarterSection = { link = "Title" },
    MiniSurround = { link = "IncSearch" },
    MiniTablineFill = { link = "TabLineFill" },

    -- ggandor/lightspeed.nvim
    LightspeedLabel = syntax_entry(palette.red, palette.none, { styles.bold, styles.underline }),
    LightspeedLabelDistant = syntax_entry(palette.blue, palette.none, { styles.bold, styles.underline }),
    LightspeedShortcut = syntax_entry(palette.bg0, palette.red, { styles.bold }),
    LightspeedUnlabeledMatch = syntax_entry(palette.fg, palette.none, { styles.bold }),
    LightspeedPendingOpArea = syntax_entry(palette.bg0, palette.green),
    LightspeedMaskedChar = { link = "Purple" },
    LightspeedGreyWash = { link = "Grey" },

    -- https://github.com/junegunn/vim-plug
    plug1 = syntax_entry(palette.orange, palette.none, { styles.bold }),
    plugNumber = syntax_entry(palette.yellow, palette.none, { styles.bold }),
    plug2 = { link = "Green" },
    plugBracket = { link = "Grey" },
    plugName = { link = "Aqua" },
    plugDash = { link = "Orange" },
    plugError = { link = "Red" },
    plugNotLoaded = { link = "Grey" },
    plugRelDate = { link = "Grey" },
    plugH2 = { link = "Orange" },
    plugMessage = { link = "Orange" },
    plugStar = { link = "Red" },
    plugUpdate = { link = "Blue" },
    plugDeleted = { link = "Grey" },
    plugEdge = { link = "Yellow" },
    plugSha = { link = "Green" },

    -- https://github.com/wbthomason/packer.nvim
    packerSuccess = { link = "Aqua" },
    packerFail = { link = "Red" },
    packerStatusSuccess = { link = "Fg" },
    packerStatusFail = { link = "Fg" },
    packerWorking = { link = "Yellow" },
    packerString = { link = "Yellow" },
    packerPackageNotLoaded = { link = "Grey" },
    packerRelDate = { link = "Grey" },
    packerPackageName = { link = "Green" },
    packerOutput = { link = "Orange" },
    packerHash = { link = "Green" },
    packerTimeTrivial = { link = "Blue" },
    packerTimeHigh = { link = "Red" },
    packerTimeMedium = { link = "Yellow" },
    packerTimeLow = { link = "Green" },

    -- https://github.com/majutsushi/tagbar
    TagbarFoldIcon = { link = "Green" },
    TagbarSignature = { link = "Green" },
    TagbarKind = { link = "Red" },
    TagbarScope = { link = "Orange" },
    TagbarNestedKind = { link = "Aqua" },
    TagbarVisibilityPrivate = { link = "Red" },
    TagbarVisibilityPublic = { link = "Blue" },

    -- https://github.com/liuchengxu/vista.vim
    VistaBracket = { link = "Grey" },
    VistaChildrenNr = { link = "Orange" },
    VistaScope = { link = "Red" },
    VistaTag = { link = "Green" },
    VistaPrefix = { link = "Grey" },
    VistaIcon = { link = "Orange" },
    VistaScopeKind = { link = "Yellow" },
    VistaColon = { link = "Grey" },
    VistaLineNr = { link = "Grey" },
    VistaHeadNr = { link = "Fg" },
    VistaPublic = { link = "Green" },
    VistaProtected = { link = "Yellow" },
    VistaPrivate = { link = "Red" },

    -- https://github.com/simrat39/symbols-outline.nvim
    FocusedSymbol = { link = "NormalFloat" },

    -- https://github.com/stevearc/aerial.nvim
    AerialLine = { link = "CursorLine" },
    AerialGuide = { link = "LineNr" },
    AerialFileIcon = { link = "Green" },
    AerialModuleIcon = { link = "Purple" },
    AerialNamespaceIcon = { link = "Purple" },
    AerialPackageIcon = { link = "Purple" },
    AerialClassIcon = { link = "Red" },
    AerialMethodIcon = { link = "Green" },
    AerialPropertyIcon = { link = "Blue" },
    AerialFieldIcon = { link = "Green" },
    AerialConstructorIcon = { link = "Green" },
    AerialEnumIcon = { link = "Yellow" },
    AerialInterfaceIcon = { link = "Yellow" },
    AerialFunctionIcon = { link = "Green" },
    AerialVariableIcon = { link = "Blue" },
    AerialConstantIcon = { link = "Blue" },
    AerialStringIcon = { link = "Aqua" },
    AerialNumberIcon = { link = "Aqua" },
    AerialBooleanIcon = { link = "Aqua" },
    AerialArrayIcon = { link = "Aqua" },
    AerialObjectIcon = { link = "Aqua" },
    AerialKeyIcon = { link = "Red" },
    AerialNullIcon = { link = "Aqua" },
    AerialEnumMemberIcon = { link = "Aqua" },
    AerialStructIcon = { link = "Yellow" },
    AerialEventIcon = { link = "Orange" },
    AerialOperatorIcon = { link = "Orange" },
    AerialTypeParameterIcon = { link = "Yellow" },

    -- https://github.com/preservim/nerdtree
    NERDTreeDir = { link = "Green" },
    NERDTreeDirSlash = { link = "Aqua" },
    NERDTreeOpenable = { link = "Orange" },
    NERDTreeClosable = { link = "Orange" },
    NERDTreeFile = { link = "Fg" },
    NERDTreeExecFile = { link = "Yellow" },
    NERDTreeUp = { link = "Grey" },
    NERDTreeCWD = { link = "Aqua" },
    NERDTreeHelp = { link = "LightGrey" },
    NERDTreeToggleOn = { link = "Green" },
    NERDTreeToggleOff = { link = "Red" },
    NERDTreeFlags = { link = "Orange" },
    NERDTreeLinkFile = { link = "Grey" },
    NERDTreeLinkTarget = { link = "Green" },

    -- https://github.com/justinmk/vim-dirvish
    DirvishPathTail = { link = "Aqua" },
    DirvishArg = { link = "Yellow" },

    -- https://github.com/kyazdani42/nvim-tree.lua
    NvimTreeSymlink = { link = "Fg" },
    NvimTreeFolderName = { link = "Green" },
    NvimTreeRootFolder = { link = "Grey" },
    NvimTreeFolderIcon = { link = "Orange" },
    NvimTreeEmptyFolderName = { link = "Green" },
    NvimTreeOpenedFolderName = { link = "Green" },
    NvimTreeExecFile = { link = "Fg" },
    NvimTreeOpenedFile = { link = "Fg" },
    NvimTreeSpecialFile = { link = "Fg" },
    NvimTreeImageFile = { link = "Fg" },
    NvimTreeMarkdownFile = { link = "Fg" },
    NvimTreeIndentMarker = { link = "Grey" },
    NvimTreeGitDirty = { link = "Yellow" },
    NvimTreeGitStaged = { link = "Blue" },
    NvimTreeGitMerge = { link = "Orange" },
    NvimTreeGitRenamed = { link = "Purple" },
    NvimTreeGitNew = { link = "Aqua" },
    NvimTreeGitDeleted = { link = "Red" },
    NvimTreeLspDiagnosticsError = { link = "RedSign" },
    NvimTreeLspDiagnosticsWarning = { link = "YellowSign" },
    NvimTreeLspDiagnosticsInformation = { link = "BlueSign" },
    NvimTreeLspDiagnosticsHint = { link = "GreenSign" },

    -- nvim-neo-tree/neo-tree.nvim
    NeoTreeDirectoryIcon = { link = "Orange" },
    NeoTreeGitAdded = { link = "Green" },
    NeoTreeGitConflict = { link = "Yellow" },
    NeoTreeGitDeleted = { link = "Red" },
    NeoTreeGitIgnored = { link = "Grey" },
    NeoTreeGitModified = { link = "Blue" },
    NeoTreeGitUnstaged = { link = "Purple" },
    NeoTreeGitUntracked = { link = "Fg" },
    NeoTreeGitStaged = { link = "Purple" },
    NeoTreeDimText = { link = "Grey" },
    NeoTreeIndentMarker = { link = "NonText" },
    NeoTreeNormalNC = { link = "NeoTreeNormal" },
    NeoTreeSignColumn = { link = "NeoTreeNormal" },
    NeoTreeRootName = { link = "Title" },

    -- https://github.com/lambdalisue/fern.vim
    FernMarkedLine = { link = "Purple" },
    FernMarkedText = { link = "Purple" },
    FernRootSymbol = { link = "FernRootText" },
    FernRootText = { link = "Orange" },
    FernLeafSymbol = { link = "FernLeafText" },
    FernLeafText = { link = "Fg" },
    FernBranchSymbol = { link = "FernBranchText" },
    FernBranchText = { link = "Green" },
    FernWindowSelectIndicator = { link = "TabLineSel" },
    FernWindowSelectStatusLine = { link = "TabLine" },

    -- https://github.com/pwntester/octo.nvim
    OctoViewer = syntax_entry(palette.bg0, palette.blue),
    OctoGreenFloat = syntax_entry(palette.green, palette.bg2),
    OctoRedFloat = syntax_entry(palette.red, palette.bg2),
    OctoPurpleFloat = syntax_entry(palette.purple, palette.bg2),
    OctoYellowFloat = syntax_entry(palette.yellow, palette.bg2),
    OctoBlueFloat = syntax_entry(palette.blue, palette.bg2),
    OctoGreyFloat = syntax_entry(palette.grey1, palette.bg2),
    OctoBubbleGreen = syntax_entry(palette.bg0, palette.green),
    OctoBubbleRed = syntax_entry(palette.bg0, palette.red),
    OctoBubblePurple = syntax_entry(palette.bg0, palette.purple),
    OctoBubbleYellow = syntax_entry(palette.bg0, palette.yellow),
    OctoBubbleBlue = syntax_entry(palette.bg0, palette.blue),
    OctoBubbleGrey = syntax_entry(palette.bg0, palette.grey1),
    OctoGreen = { link = "Green" },
    OctoRed = { link = "Red" },
    OctoPurple = { link = "Purple" },
    OctoYellow = { link = "Yellow" },
    OctoBlue = { link = "Blue" },
    OctoGrey = { link = "Grey" },
    OctoBubbleDelimiterGreen = { link = "Green" },
    OctoBubbleDelimiterRed = { link = "Red" },
    OctoBubbleDelimiterPurple = { link = "Purple" },
    OctoBubbleDelimiterYellow = { link = "Yellow" },
    OctoBubbleDelimiterBlue = { link = "Blue" },
    OctoBubbleDelimiterGrey = { link = "Grey" },

    -- netrw
    netrwDir = { link = "Green" },
    netrwClassify = { link = "Green" },
    netrwLink = { link = "Grey" },
    netrwSymLink = { link = "Fg" },
    netrwExe = { link = "Yellow" },
    netrwComment = { link = "Grey" },
    netrwList = { link = "Aqua" },
    netrwHelpCmd = { link = "Blue" },
    netrwCmdSep = { link = "Grey" },
    netrwVersion = { link = "Orange" },

    -- https://github.com/mhinz/vim-startify
    StartifyBracket = { link = "Grey" },
    StartifyFile = { link = "Fg" },
    StartifyNumber = { link = "Orange" },
    StartifyPath = { link = "Green" },
    StartifySlash = { link = "Green" },
    StartifySection = { link = "Yellow" },
    StartifyHeader = { link = "Aqua" },
    StartifySpecial = { link = "Grey" },
    StartifyFooter = { link = "Grey" },

    -- https://github.com/skywind3000/quickmenu.vim
    QuickmenuOption = { link = "Green" },
    QuickmenuNumber = { link = "Red" },
    QuickmenuBracket = { link = "Grey" },
    QuickmenuHelp = { link = "Green" },
    QuickmenuSpecial = { link = "Purple" },
    QuickmenuHeader = { link = "Orange" },

    -- mbbill/undotree
    UndotreeSavedBig = syntax_entry(palette.purple, palette.none, { styles.bold }),
    UndotreeNode = { link = "Orange" },
    UndotreeNodeCurrent = { link = "Red" },
    UndotreeSeq = { link = "Green" },
    UndotreeNext = { link = "Blue" },
    UndotreeTimeStamp = { link = "Grey" },
    UndotreeHead = { link = "Yellow" },
    UndotreeBranch = { link = "Yellow" },
    UndotreeCurrent = { link = "Aqua" },
    UndotreeSavedSmall = { link = "Purple" },

    -- NeogitOrg/neogit
    NeogitBranch = { link = "Green" },
    NeogitChangeAdded = { link = "GreenBold" },
    NeogitChangeBothModified = { link = "YellowBold" },
    NeogitChangeCopied = { link = "AquaBold" },
    NeogitChangeDeleted = { link = "RedBold" },
    NeogitChangeModified = { link = "OrangeBold" },
    NeogitChangeNewFile = { link = "GreenBold" },
    NeogitChangeRenamed = { link = "BlueBold" },
    NeogitChangeUpdated = { link = "YellowBold" },
    NeogitCommandCodeError = { link = "Red" },
    NeogitCommandCodeNormal = { link = "Green" },
    NeogitCommitViewHeader = { link = "Purple" },
    NeogitDiffAdd = { link = "DiffAdd" },
    NeogitDiffAddHighlight = { link = "DiffAdd" },
    NeogitDiffContextHighlight = { link = "CursorLine" },
    NeogitDiffDelete = { link = "DiffDelete" },
    NeogitDiffDeleteHighlight = { link = "DiffDelete" },
    NeogitFilePath = { link = "Aqua" },
    NeogitFold = { link = "FoldColumn" },
    NeogitHunkHeader = { link = "TabLineFill" },
    NeogitHunkHeaderHighlight = { link = "TabLine" },
    NeogitNotificationError = { link = "ErrorFloat" },
    NeogitNotificationInfo = { link = "InfoFloat" },
    NeogitNotificationWarning = { link = "WarningFloat" },
    NeogitObjectId = syntax_entry(palette.green, palette.none, { styles.italic, styles.bold }),
    NeogitRecentCommits = { link = "AquaBold" },
    NeogitRemote = { link = "Purple" },
    NeogitStashes = { link = "BlueBold" },
    NeogitUnmergedInto = { link = "PurpleItalic" },
    NeogitUnpushedTo = { link = "PurpleItalic" },
    NeogitUnstagedchanges = { link = "Aqua" },
    NeogitUntrackedfiles = { link = "PurpleItalic" },

    -- glepnir/dashboard-nvim
    DashboardHeader = { link = "Yellow" },
    DashboardCenter = { link = "Green" },
    DashboardShortcut = { link = "Red" },
    DashboardFooter = { link = "Orange" },

    -- nvim-neotest/neotest
    NeotestPassed = syntax_entry(palette.green, palette.none),
    NeotestRunning = syntax_entry(palette.yellow, palette.none),
    NeotestFailed = syntax_entry(palette.red, palette.none),
    NeotestSkipped = syntax_entry(palette.blue, palette.none),
    NeotestNamespace = syntax_entry(palette.bg_green, palette.none),
    NeotestFocused = syntax_entry(palette.yellow, palette.none),
    NeotestFile = syntax_entry(palette.aqua, palette.none),
    NeotestDir = syntax_entry(palette.blue, palette.none),
    NeotestBorder = syntax_entry(palette.blue, palette.none),
    NeotestIndent = syntax_entry(palette.grey1, palette.none),
    NeotestExpandMarker = syntax_entry(palette.grey1, palette.none),
    NeotestAdapterName = syntax_entry(palette.purple, palette.none, { styles.bold }),
    NeotestWinSelect = syntax_entry(palette.blue, palette.none),
    NeotestMarked = syntax_entry(palette.blue, palette.none),
    NeotestTarget = syntax_entry(palette.blue, palette.none),

    -- lambdalisue/glyph-palette.vim
    GlyphPalette1 = syntax_entry(palette.red, palette.none),
    GlyphPalette2 = syntax_entry(palette.green, palette.none),
    GlyphPalette3 = syntax_entry(palette.yellow, palette.none),
    GlyphPalette4 = syntax_entry(palette.blue, palette.none),
    GlyphPalette6 = syntax_entry(palette.green, palette.none),
    GlyphPalette7 = syntax_entry(palette.fg, palette.none),
    GlyphPalette9 = syntax_entry(palette.red, palette.none),

    -- akinsho/bufferline.nvim
    BufferLineIndicatorSelected = { link = "GreenSign" },

    -- petertriho/nvim-scrollbar
    ScrollbarHandle = syntax_entry(palette.none, palette.bg1),
    ScrollbarSearchHandle = syntax_entry(palette.orange, palette.bg1),
    ScrollbarSearch = syntax_entry(palette.orange, palette.none),
    ScrollbarErrorHandle = syntax_entry(palette.red, palette.bg1),
    ScrollbarError = syntax_entry(palette.red, palette.none),
    ScrollbarWarnHandle = syntax_entry(palette.yellow, palette.bg1),
    ScrollbarWarn = syntax_entry(palette.yellow, palette.none),
    ScrollbarInfoHandle = syntax_entry(palette.green, palette.bg1),
    ScrollbarInfo = syntax_entry(palette.green, palette.none),
    ScrollbarHintHandle = syntax_entry(palette.blue, palette.bg1),
    ScrollbarHint = syntax_entry(palette.blue, palette.none),
    ScrollbarMiscHandle = syntax_entry(palette.purple, palette.bg1),
    ScrollbarMisc = syntax_entry(palette.purple, palette.none),

    -- gbprod/yanky.nvim
    YankyPut = { link = "IncSearch" },
    YankyYanked = { link = "IncSearch" },

    -- folke/noice.nvim
    NoiceCompletionItemKindDefault = syntax_entry(palette.grey1, palette.none),
    NoiceCompletionItemKindKeyword = syntax_entry(palette.aqua, palette.none),
    NoiceCompletionItemKindVariable = syntax_entry(palette.statusline3, palette.none),
    NoiceCompletionItemKindConstant = syntax_entry(palette.statusline3, palette.none),
    NoiceCompletionItemKindReference = syntax_entry(palette.statusline3, palette.none),
    NoiceCompletionItemKindValue = syntax_entry(palette.statusline3, palette.none),
    NoiceCompletionItemKindFunction = syntax_entry(palette.blue, palette.none),
    NoiceCompletionItemKindMethod = syntax_entry(palette.blue, palette.none),
    NoiceCompletionItemKindConstructor = syntax_entry(palette.blue, palette.none),
    NoiceCompletionItemKindClass = syntax_entry(palette.orange, palette.none),
    NoiceCompletionItemKindInterface = syntax_entry(palette.orange, palette.none),
    NoiceCompletionItemKindStruct = syntax_entry(palette.orange, palette.none),
    NoiceCompletionItemKindEvent = syntax_entry(palette.orange, palette.none),
    NoiceCompletionItemKindEnum = syntax_entry(palette.orange, palette.none),
    NoiceCompletionItemKindUnit = syntax_entry(palette.orange, palette.none),
    NoiceCompletionItemKindModule = syntax_entry(palette.yellow, palette.none),
    NoiceCompletionItemKindProperty = syntax_entry(palette.green, palette.none),
    NoiceCompletionItemKindField = syntax_entry(palette.green, palette.none),
    NoiceCompletionItemKindTypeParameter = syntax_entry(palette.green, palette.none),
    NoiceCompletionItemKindEnumMember = syntax_entry(palette.green, palette.none),
    NoiceCompletionItemKindOperator = syntax_entry(palette.green, palette.none),
    NoiceCompletionItemKindSnippet = syntax_entry(palette.grey1, palette.none),

    -- nullchilly/fsread.nvim
    FSPrefix = syntax_entry(palette.fg, transparency_respecting_colour(palette.bg0), { styles.bold }),
    FSSuffix = syntax_entry(palette.grey1, palette.none),

    -- Language specific settings
    -- Markdown
    markdownH1 = syntax_entry(palette.red, palette.none, { styles.bold }),
    markdownH2 = syntax_entry(palette.orange, palette.none, { styles.bold }),
    markdownH3 = syntax_entry(palette.yellow, palette.none, { styles.bold }),
    markdownH4 = syntax_entry(palette.green, palette.none, { styles.bold }),
    markdownH5 = syntax_entry(palette.blue, palette.none, { styles.bold }),
    markdownH6 = syntax_entry(palette.purple, palette.none, { styles.bold }),
    markdownUrl = syntax_entry(palette.blue, palette.none, { styles.underline }),
    markdownItalic = syntax_entry(palette.none, palette.none, { styles.italic }),
    markdownBold = syntax_entry(palette.none, palette.none, { styles.bold }),
    markdownItalicDelimiter = syntax_entry(palette.grey1, palette.none, { styles.italic }),
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
    htmlH1 = syntax_entry(palette.red, palette.none, { styles.bold }),
    htmlH2 = syntax_entry(palette.orange, palette.none, { styles.bold }),
    htmlH3 = syntax_entry(palette.yellow, palette.none, { styles.bold }),
    htmlH4 = syntax_entry(palette.green, palette.none, { styles.bold }),
    htmlH5 = syntax_entry(palette.blue, palette.none, { styles.bold }),
    htmlH6 = syntax_entry(palette.purple, palette.none, { styles.bold }),
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

    -- JS/X
    javaScriptNull = { link = "Aqua" },
    javaScriptNumber = { link = "Number" },
    javaScriptIdentifier = { link = "Orange" },
    javaScriptGlobal = { link = "Purple" },
    javaScriptMessage = { link = "Yellow" },
    javaScriptFunction = { link = "Keyword" },
    javaScriptOperator = { link = "Orange" },
    javaScriptMember = { link = "Aqua" },

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

    -- Ruby
    rubyKeywordAsMethod = { link = "Green" },
    rubyInterpolation = { link = "Yellow" },
    rubyInterpolationDelimiter = { link = "Yellow" },
    rubyStringDelimiter = { link = "Green" },
    rubyBlockParameterList = { link = "Blue" },
    rubyDefine = { link = "RedItalic" },
    rubyModuleName = { link = "Purple" },
    rubyAccess = { link = "Orange" },
    rubyAttribute = { link = "Yellow" },
    rubyMacro = { link = "RedItalic" },

    -- Elixir
    elixirStringDelimiter = { link = "Green" },
    elixirKeyword = { link = "Orange" },
    elixirInterpolation = { link = "Yellow" },
    elixirInterpolationDelimiter = { link = "Yellow" },
    elixirSelf = { link = "Purple" },
    elixirPseudoVariable = { link = "Purple" },
    elixirModuleDefine = { link = "PurpleItalic" },
    elixirBlockDefinition = { link = "RedItalic" },
    elixirDefine = { link = "RedItalic" },
    elixirPrivateDefine = { link = "RedItalic" },
    elixirGuard = { link = "RedItalic" },
    elixirPrivateGuard = { link = "RedItalic" },
    elixirProtocolDefine = { link = "RedItalic" },
    elixirImplDefine = { link = "RedItalic" },
    elixirRecordDefine = { link = "RedItalic" },
    elixirPrivateRecordDefine = { link = "RedItalic" },
    elixirMacroDefine = { link = "RedItalic" },
    elixirPrivateMacroDefine = { link = "RedItalic" },
    elixirDelegateDefine = { link = "RedItalic" },
    elixirOverridableDefine = { link = "RedItalic" },
    elixirExceptionDefine = { link = "RedItalic" },
    elixirCallbackDefine = { link = "RedItalic" },
    elixirStructDefine = { link = "RedItalic" },
    elixirExUnitMacro = { link = "RedItalic" },

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
    shFunctionOne = { link = "Green" },
    shFunctionKey = { link = "RedItalic" },

    -- ZSH
    zshOptStart = { link = "PurpleItalic" },
    zshOption = { link = "Blue" },
    zshSubst = { link = "Yellow" },
    zshFunction = { link = "Green" },
    zshDeref = { link = "Blue" },
    zshTypes = { link = "Orange" },
    zshVariableDef = { link = "Blue" },

    -- VimL
    vimLet = { link = "Orange" },
    vimFunction = { link = "Green" },
    vimIsCommand = { link = "Fg" },
    vimUserFunc = { link = "Green" },
    vimFuncName = { link = "Green" },
    vimMap = { link = "PurpleItalic" },
    vimNotation = { link = "Aqua" },
    vimMapLhs = { link = "Green" },
    vimMapRhs = { link = "Green" },
    vimSetEqual = { link = "Yellow" },
    vimOption = { link = "Aqua" },
    vimUserAttrbKey = { link = "Yellow" },
    vimUserAttrb = { link = "Green" },
    vimAutoCmdSfxList = { link = "Aqua" },
    vimSynType = { link = "Orange" },
    vimHiBang = { link = "Orange" },
    vimSet = { link = "Yellow" },
    vimSetSep = { link = "Grey" },
    vimContinue = { link = "Grey" },

    -- Make
    makeIdent = { link = "Aqua" },
    makeSpecTarget = { link = "Yellow" },
    makeTarget = { link = "Blue" },
    makeCommands = { link = "Orange" },
  }

  -- nathanaelkane/vim-indent-guides
  if vim.g.indent_guides_auto_colors == false then
    syntax["IndentGuidesOdd"] = syntax_entry(palette.bg0, palette.bg1)
    syntax["IndentGuidesEven"] = syntax_entry(palette.bg0, palette.bg2)
  end

  if options.transparent_background_level == 0 then
    syntax["NvimTreeNormal"] = syntax_entry(palette.fg, palette.bg_dim)
    syntax["NvimTreeEndOfBuffer"] = syntax_entry(palette.bg_dim, palette.bg_dim)
    syntax["NvimTreeVertSplit"] = syntax_entry(palette.bg0, palette.bg0)
    syntax["NvimTreeCursorLine"] = syntax_entry(palette.none, palette.bg0)
    syntax["NeoTreeNormal"] = syntax_entry(palette.fg, palette.bg_dim)
    syntax["NeoTreeEndOfBuffer"] = syntax_entry(palette.bg_dim, palette.bg_dim)
    syntax["NeoTreeVertSplit"] = syntax_entry(palette.bg0, palette.bg0)
  end

  -- Terminal colours
  local terminal = {
    red = palette.red,
    yellow = palette.yellow,
    green = palette.green,
    cyan = palette.aqua,
    blue = palette.blue,
    purple = palette.purple,
  }

  if vim.o.background == "dark" then
    terminal.black = palette.fg
    terminal.white = palette.bg3
  else
    terminal.black = palette.bg3
    terminal.white = palette.fg
  end

  -- Consider adding configuration options for this
  vim.g.terminal_color_0 = terminal.black
  vim.g.terminal_color_1 = terminal.red
  vim.g.terminal_color_2 = terminal.green
  vim.g.terminal_color_3 = terminal.yellow
  vim.g.terminal_color_4 = terminal.blue
  vim.g.terminal_color_5 = terminal.purple
  vim.g.terminal_color_6 = terminal.cyan
  vim.g.terminal_color_7 = terminal.white
  vim.g.terminal_color_8 = terminal.black
  vim.g.terminal_color_9 = terminal.red
  vim.g.terminal_color_10 = terminal.green
  vim.g.terminal_color_11 = terminal.yellow
  vim.g.terminal_color_12 = terminal.blue
  vim.g.terminal_color_13 = terminal.purple
  vim.g.terminal_color_14 = terminal.cyan
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
  vim.g.limelight_conceal_ctermfg = palette.grey0
  vim.g.limelight_conceal_guifg = palette.grey0

  options.on_highlights(syntax, palette)

  return syntax
end

return highlights
