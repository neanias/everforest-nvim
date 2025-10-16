-- General UI plugin groups (telescope, snacks, which-key, bufferline, scrollbar, flash, leap, incline, notify, fzf, etc.)
local util = require("forestflower.util")
return function(theme, options)
  local palette, ui = theme.palette, theme.ui
  local function syntax_entry(fg, bg, stylings)
    local h = { fg = fg, bg = bg }
    if stylings then for _, s in ipairs(stylings) do h[s] = true end end
    return h
  end
  local styles = { bold = "bold", italic = "italic", nocombine = "nocombine" }

  local t = {
    -- which-key
    WhichKey = { link = "Red" },
    WhichKeyDesc = { link = "Blue" },
    WhichKeyFloat = syntax_entry(palette.none, palette.surface),
    WhichKeyGroup = { link = "Yellow" },
    WhichKeySeparator = { link = "Green" },
    WhichKeyValue = syntax_entry(palette.on_surface, palette.none),
    -- highlightedyank
    HighlightedyankRegion = { link = "Visual" },
    -- telescope
    TelescopeMatching = syntax_entry(palette.success, palette.none, { styles.bold }),
    TelescopeBorder = { link = "Grey" },
    TelescopePromptPrefix = { link = "Orange" },
    TelescopeSelection = { link = "DiffAdd" },
    -- snacks.nvim picker
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
    -- sidekick
    SidekickDiffAdd = { link = "DiffAdd" },
    SidekickDiffContext = { link = "DiffChange" },
    SidekickDiffDelete = { link = "DiffDelete" },
    SidekickSignAdd = { fg = "#449dab" },
    SidekickSignChange = { fg = "#6183bb" },
    SidekickSignDelete = { fg = "#914c54" },
    -- fzf-lua
    FzfLuaBorder = { link = "Grey" },
    -- flash.nvim
    FlashBackdrop = syntax_entry(palette.on_surface_variant, palette.none),
    FlashLabel = syntax_entry(palette.warning, palette.none, { styles.bold, styles.italic }),
    FlashMatch = syntax_entry(palette.warning, palette.none, { styles.bold }),
    FlashCurrent = syntax_entry(palette.warning, palette.none, { styles.bold }),
    -- leap
    LeapMatch = syntax_entry(palette.on_surface, palette.tertiary, { styles.bold }),
    LeapLabel = syntax_entry(palette.tertiary, palette.none, { styles.bold }),
    LeapBackdrop = syntax_entry(palette.on_surface_variant, palette.none),
    -- indent-blankline / ibl
    IblScope = syntax_entry(palette.on_surface_variant, palette.none, { styles.nocombine }),
    IblIndent = syntax_entry(palette.bg4, palette.none, { styles.nocombine }),
    IndentBlanklineContextChar = { link = "IblScope" },
    IndentBlanklineChar = { link = "IblIndent" },
    IndentBlanklineSpaceChar = { link = "IndentBlanklineChar" },
    IndentBlanklineSpaceCharBlankline = { link = "IndentBlanklineChar" },
    -- navic
    NavicText = syntax_entry(palette.on_surface, palette.none),
    NavicSeparator = syntax_entry(palette.on_surface, palette.none),
    -- notify
    NotifyBackground = syntax_entry(palette.none, palette.background),
    NotifyDEBUGBorder = { link = "Grey" },
    NotifyERRORBorder = { link = "Red" },
    NotifyINFOBorder = { link = "Green" },
    NotifyTRACEBorder = { link = "Purple" },
    NotifyWARNBorder = { link = "Yellow" },
    NotifyDEBUGIcon = { link = "Grey" },
    NotifyERRORIcon = { link = "Red" },
    NotifyINFOIcon = { link = "Green" },
    NotifyTRACEIcon = { link = "Purple" },
    NotifyWARNIcon = { link = "Yellow" },
    NotifyDEBUGTitle = { link = "Grey" },
    NotifyERRORTitle = { link = "Red" },
    NotifyINFOTitle = { link = "Green" },
    NotifyTRACETitle = { link = "Purple" },
    NotifyWARNTitle = { link = "Yellow" },
    -- incline
    InclineNormalNC = syntax_entry(palette.on_surface_variant, palette.surface_variant),
    -- bufferline (subset)
    BufferLineIndicatorSelected = { link = "GreenSign" },
    -- scrollbar
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
    -- yanky
    YankyPut = { link = "IncSearch" },
    YankyYanked = { link = "IncSearch" },
    -- fzf.vim global colours (can't be links, set via vim.g externally)
    -- defined elsewhere in original; we keep group links minimal here.
  }
  return t
end