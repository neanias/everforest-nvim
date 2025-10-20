---Plugin highlight groups
---Third-party plugin integrations

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
    -- Telescope
    TelescopeMatching = create(palette.success, palette.none, { styles.bold }),
    TelescopeBorder = link("Grey"),
    TelescopePromptPrefix = link("Orange"),
    TelescopeSelection = link("DiffAdd"),

    -- Which-key
    WhichKey = link("Red"),
    WhichKeyDesc = link("Blue"),
    WhichKeyFloat = create(palette.none, palette.surface),
    WhichKeyGroup = link("Yellow"),
    WhichKeySeparator = link("Green"),
    WhichKeyValue = create(ui.on_surface, palette.none),

    -- Flash
    FlashBackdrop = create(ui.on_surface_variant, palette.none),
    FlashLabel = create(palette.warning, palette.none, { styles.bold, styles.italic }),
    FlashMatch = create(palette.warning, palette.none, { styles.bold }),
    FlashCurrent = create(palette.warning, palette.none, { styles.bold }),

    -- Leap
    LeapMatch = create(ui.on_surface, palette.tertiary, { styles.bold }),
    LeapLabel = create(palette.tertiary, palette.none, { styles.bold }),
    LeapBackdrop = create(ui.on_surface_variant, palette.none),

    -- Indent blankline
    IblScope = create(ui.on_surface_variant, palette.none, { styles.nocombine }),
    IblIndent = create(ui.surface_variant, palette.none, { styles.nocombine }),
    IndentBlanklineContextChar = link("IblScope"),
    IndentBlanklineChar = link("IblIndent"),
    IndentBlanklineSpaceChar = link("IndentBlanklineChar"),
    IndentBlanklineSpaceCharBlankline = link("IndentBlanklineChar"),

    -- Navic
    NavicText = create(ui.on_surface, palette.none),
    NavicSeparator = create(ui.on_surface, palette.none),

    -- Notify
    NotifyBackground = create(palette.none, palette.background),
    NotifyDEBUGBorder = link("Grey"),
    NotifyERRORBorder = link("Red"),
    NotifyINFOBorder = link("Green"),
    NotifyTRACEBorder = link("Purple"),
    NotifyWARNBorder = link("Yellow"),
    NotifyDEBUGIcon = link("Grey"),
    NotifyERRORIcon = link("Red"),
    NotifyINFOIcon = link("Green"),
    NotifyTRACEIcon = link("Purple"),
    NotifyWARNIcon = link("Yellow"),
    NotifyDEBUGTitle = link("Grey"),
    NotifyERRORTitle = link("Red"),
    NotifyINFOTitle = link("Green"),
    NotifyTRACETitle = link("Purple"),
    NotifyWARNTitle = link("Yellow"),

    -- Incline
    InclineNormalNC = create(ui.on_surface_variant, ui.surface_variant),

    -- Bufferline
    BufferLineIndicatorSelected = link("GreenSign"),

    -- Scrollbar
    ScrollbarHandle = create(palette.none, palette.surface),
    ScrollbarSearchHandle = create(palette.warning, palette.surface),
    ScrollbarSearch = link("Yellow"),
    ScrollbarErrorHandle = create(palette.error, palette.surface),
    ScrollbarError = link("Red"),
    ScrollbarWarnHandle = create(palette.warning, palette.surface),
    ScrollbarWarn = link("Yellow"),
    ScrollbarInfoHandle = create(palette.success, palette.surface),
    ScrollbarInfo = link("Green"),
    ScrollbarHintHandle = create(palette.info, palette.surface),
    ScrollbarHint = link("Blue"),
    ScrollbarMiscHandle = create(palette.tertiary, palette.surface),
    ScrollbarMisc = link("Purple"),

    -- Yanky
    YankyPut = link("IncSearch"),
    YankyYanked = link("IncSearch"),

    -- Highlighted yank
    HighlightedyankRegion = link("Visual"),

    -- Current word
    CurrentWord = create(palette.none, palette.none, { styles.bold }),
    CurrentWordTwins = link("CurrentWord"),

    -- Illuminate
    IlluminatedWordText = link("CurrentWord"),
    IlluminatedWordRead = link("CurrentWord"),
    IlluminatedWordWrite = link("CurrentWord"),

    -- Quick scope
    QuickScopePrimary = create(palette.secondary, palette.none, { styles.underline }),
    QuickScopeSecondary = create(palette.info, palette.none, { styles.underline }),
  }
end

