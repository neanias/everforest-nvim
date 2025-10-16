-- Core editor, diagnostics, basic syntax, treesitter & semantic tokens.
-- Extracted from highlights.generate_syntax monolith.
local util = require("forestflower.util")

return function(theme, options)
  local palette, ui, syn, status = theme.palette, theme.ui, theme.syntax, theme.status
  local styles = {
    italic = "italic",
    bold = "bold",
    underline = "underline",
    undercurl = "undercurl",
    reverse = "reverse",
    strikethrough = "strikethrough",
    nocombine = "nocombine",
  }

  local function syntax_entry(fg, bg, stylings, sp)
    local highlight = { fg = fg, bg = bg }
    if stylings then
      for _, style in ipairs(stylings) do
        highlight[style] = true
      end
    end
    if sp then highlight.sp = sp end
    return highlight
  end

  local comment_italics = options.disable_italic_comments and {} or { styles.italic }
  local optional_italics = options.italics and { styles.italic } or {}

  local function transparency_respecting_colour(c)
    if options.transparent_background_level > 0 then return palette.none else return c end
  end
  local function set_signs_background_colour(c)
    if options.transparent_background_level > 0 or options.sign_column_background == "none" then
      return palette.none
    else
      return c
    end
  end
  local function sign_column_respecting_colour(c)
    if options.sign_column_background == "none" then return palette.none else return c end
  end
  local function set_colour_based_on_ui_contrast(low, other)
    if options.ui_contrast == "low" then return low else return other end
  end

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
    Normal = syntax_entry(ui.fg, transparency_respecting_colour(ui.background)),
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
    Search = syntax_entry(ui.background, ui.primary),
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
    Visual = syntax_entry(palette.none, ui.selection),
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
    VirtualTextWarning = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Yellow" },
    VirtualTextError = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Red" },
    VirtualTextInfo = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Blue" },
    VirtualTextHint = { link = options.diagnostic_virtual_text == "grey" and "Grey" or "Green" },
    ErrorFloat = syntax_entry(status.error, palette.none),
    WarningFloat = syntax_entry(status.warning, palette.none),
    InfoFloat = syntax_entry(status.info, palette.none),
    HintFloat = syntax_entry(status.hint, palette.none),
    InlayHints = syntax_entry(syn.comment, palette.none),
    CurrentWord = syntax_entry(palette.none, palette.none, { styles.bold }),
    -- Treesitter markdown kept minimal
    markdownH1 = syntax_entry(palette.error, palette.none, { styles.bold }),
    markdownH2 = syntax_entry(palette.warning, palette.none, { styles.bold }),
    markdownH3 = syntax_entry(palette.warning, palette.none, { styles.bold }),
    markdownH4 = syntax_entry(palette.success, palette.none, { styles.bold }),
    markdownH5 = syntax_entry(palette.info, palette.none, { styles.bold }),
    markdownH6 = syntax_entry(palette.tertiary, palette.none, { styles.bold }),
    markdownUrl = { link = "TSURI" },
    markdownItalic = syntax_entry(palette.none, palette.none, { styles.italic }),
    markdownBold = syntax_entry(palette.none, palette.none, { styles.bold }),
  }

  if options.inlay_hints_background == "none" then
    syntax["InlayHints"] = { link = "LineNr" }
  elseif options.inlay_hints_background == "dimmed" then
    syntax["InlayHints"] = syntax_entry(palette.outline, palette.surface)
  elseif options.inlay_hints_background == "soft" then
    local soft_bg = util.blend(palette.surface, 0.60, palette.background)
    syntax["InlayHints"] = syntax_entry(palette.outline, soft_bg)
  end

  return syntax
end