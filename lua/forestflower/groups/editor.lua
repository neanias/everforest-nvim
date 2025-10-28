---Editor highlight groups
---Core editor functionality, cursor, selection, etc.

local highlights = require("forestflower.core.highlights")

---@param theme ForestflowerTheme
---@param config ThemeConfig
---@return Highlights
return function(theme, config)
  local palette, ui = theme.palette, theme.ui
  local create = highlights.create
  local link = highlights.link
  local styles = highlights.styles

  return {
    -- Core editor
    Normal = create(ui.on_surface, config.transparent_background_level > 0 and palette.none or ui.background),
    NormalFloat = create(
      ui.on_surface,
      config.float_style == "bright" and ui.float_background or ui.float_background_dim
    ),
    NormalNC = create(ui.on_surface, config.transparent_background_level > 0 and palette.none or ui.background),

    -- Cursor
    Cursor = create(palette.none, palette.none, { styles.reverse }),
    lCursor = link("Cursor"),
    CursorIM = link("Cursor"),
    TermCursor = link("Cursor"),
    TermCursorNC = link("Cursor"),

    -- Selection
    Visual = create(palette.none, ui.selection),
    VisualNOS = link("Visual"),

    -- Line numbers
    LineNr = create(ui.outline, palette.none),
    LineNrAbove = link("LineNr"),
    LineNrBelow = link("LineNr"),
    CursorLineNr = create(ui.primary, palette.none, { styles.bold }),

    -- Cursor line
    CursorLine = create(palette.none, ui.surface_variant),
    CursorColumn = create(palette.none, ui.surface),

    -- Search
    Search = create(ui.background, ui.primary),
    IncSearch = link("Search"),
    CurSearch = link("IncSearch"),
    Substitute = create(ui.background, palette.warning),

    -- Status line
    StatusLine = create(
      ui.statusline_fg,
      config.transparent_background_level == 2 and palette.none or ui.statusline_bg
    ),
    StatusLineNC = create(
      ui.statusline_nc_fg,
      config.transparent_background_level == 2 and palette.none or ui.statusline_nc_bg
    ),

    -- Tabs
    TabLine = create(ui.tab_inactive_fg, ui.tab_inactive_bg),
    TabLineFill = create(ui.tab_fill_fg, config.transparent_background_level == 2 and palette.none or ui.tab_fill_bg),
    TabLineSel = create(ui.on_surface, ui.tab_active_bg, { styles.bold }),

    -- Tab modifications (unsaved changes)
    TabLineModified = create(palette.primary, ui.tab_inactive_bg),
    TabLineSelModified = create(palette.primary, ui.tab_active_bg, { styles.bold }),

    -- Tab separators and borders
    TabLineClose = create(ui.on_surface_variant, ui.tab_inactive_bg),
    TabLineSelClose = create(ui.on_surface, ui.tab_active_bg, { styles.bold }),

    -- Mini.tabline highlight groups
    MiniTablineCurrent = create(ui.on_surface, ui.tab_active_bg, { styles.bold }),
    MiniTablineVisible = create(ui.tab_inactive_fg, ui.tab_inactive_bg),
    MiniTablineHidden = create(ui.on_surface_variant, ui.tab_inactive_bg),
    MiniTablineModifiedCurrent = create(ui.primary, ui.tab_active_bg, { styles.bold }),
    MiniTablineModifiedVisible = create(ui.primary, ui.tab_inactive_bg),
    MiniTablineModifiedHidden = create(ui.primary, ui.tab_inactive_bg),
    MiniTablineFill = create(
      ui.tab_fill_fg,
      config.transparent_background_level == 2 and palette.none or ui.tab_fill_bg
    ),
    MiniTablineTabpagesection = create(ui.on_surface_variant, ui.tab_inactive_bg),
    MiniTablineTrunc = create(ui.on_surface_variant, ui.tab_inactive_bg),

    -- Windows
    WinBar = create(
      ui.on_surface_variant,
      config.transparent_background_level == 2 and palette.none or ui.surface,
      { styles.bold }
    ),
    WinBarNC = create(
      ui.on_surface_variant,
      config.transparent_background_level == 2 and palette.none or ui.surface_variant
    ),
    WinSeparator = create(ui.background, ui.background),
    VertSplit = link("WinSeparator"),

    -- Borders
    FloatBorder = create(
      ui.float_border,
      config.float_style == "bright" and ui.float_background or ui.float_background_dim
    ),
    FloatTitle = create(
      ui.float_title,
      config.float_style == "bright" and ui.float_background or ui.float_background_dim,
      { styles.bold }
    ),

    -- End of buffer
    EndOfBuffer = create(config.show_eob and ui.surface_variant or ui.background, palette.none),

    -- Messages
    ErrorMsg = create(palette.error, palette.none, { styles.bold, styles.underline }),
    WarningMsg = create(palette.warning, palette.none, { styles.bold }),
    ModeMsg = create(ui.on_surface, palette.none, { styles.bold }),
    MoreMsg = create(palette.warning, palette.none, { styles.bold }),
    Question = create(palette.warning, palette.none),

    -- Special
    SpecialKey = create(palette.warning, palette.none),
    NonText = create(ui.on_surface_variant, palette.none),
    Whitespace = create(ui.on_surface_variant, palette.none),

    -- Inline annotations
    InlayHints = create(ui.hint, ui.hint_container),

    Directory = create(ui.success, palette.none),
    Title = create(palette.warning, palette.none, { styles.bold }),

    -- Folding
    Folded = create(ui.on_surface_variant, config.transparent_background_level > 0 and palette.none or ui.surface),
    FoldColumn = create(ui.outline, config.sign_column_background == "none" and palette.none or ui.surface),

    -- Signs
    SignColumn = create(ui.on_surface, config.sign_column_background == "none" and palette.none or ui.surface),

    -- Popup menu
    Pmenu = create(ui.on_surface, ui.popup_background),
    PmenuSel = create(ui.background, ui.selection),
    PmenuSbar = create(palette.none, ui.popup_background),
    PmenuThumb = create(palette.none, ui.scrollbar_thumb),
    WildMenu = link("PmenuSel"),

    -- Quick fix
    QuickFixLine = create(palette.tertiary, palette.none, { styles.bold }),

    -- Match paren
    MatchParen = create(palette.none, ui.surface_variant),

    -- Conceal
    Conceal = create(ui.on_surface_variant, palette.none),

    -- Color column
    ColorColumn = create(palette.none, ui.surface_variant),
  }
end
