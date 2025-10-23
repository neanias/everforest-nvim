---Snacks, Trouble, and Noice highlight groups
---Integrations for Snacks explorer/picker, trouble.nvim, and noice.nvim

local highlights = require("forestflower.core.highlights")

---@param theme ForestflowerTheme
---@param config ThemeConfig
---@return Highlights
return function(theme, config)
  local palette, ui = theme.palette, theme.ui
  local create = highlights.create
  local link = highlights.link
  local styles = highlights.styles

  local float_bg = config.float_style == "bright" and ui.float_background or ui.float_background_dim

  return {
    ---------------------------------------------------------------------------
    -- Snacks Explorer
    ---------------------------------------------------------------------------
    SnacksExplorerNormal = create(
      ui.on_surface,
      config.transparent_background_level > 0 and palette.none or ui.surface
    ),
    SnacksExplorerBorder = create(ui.surface, config.transparent_background_level > 0 and palette.none or ui.surface),
    SnacksExplorerTitle = create(
      ui.primary,
      config.transparent_background_level > 0 and palette.none or ui.surface,
      { styles.bold }
    ),
    SnacksExplorerFile = create(ui.on_surface, config.transparent_background_level > 0 and palette.none or ui.surface),
    SnacksExplorerDirectory = link("Directory"),
    SnacksExplorerSymlink = create(
      palette.secondary,
      config.transparent_background_level > 0 and palette.none or ui.surface
    ),
    SnacksExplorerHidden = create(
      ui.on_surface,
      config.transparent_background_level > 0 and palette.none or ui.surface
    ),
    SnacksExplorerDim = create(
      ui.on_surface_variant,
      config.transparent_background_level > 0 and palette.none or ui.surface
    ),
    SnacksExplorerGitIgnored = create(
      ui.on_surface_variant,
      config.transparent_background_level > 0 and palette.none or ui.surface
    ),
    SnacksExplorerGitUntracked = create(
      ui.success,
      config.transparent_background_level > 0 and palette.none or ui.surface,
      { styles.bold }
    ),
    SnacksExplorerGitModified = create(ui.warn, config.transparent_background_level > 0 and palette.none or ui.surface),
    SnacksExplorerGitDeleted = create(ui.error, config.transparent_background_level > 0 and palette.none or ui.surface),
    SnacksExplorerGitRenamed = create(ui.info, config.transparent_background_level > 0 and palette.none or ui.surface),
    SnacksExplorerGitStaged = create(
      palette.secondary,
      config.transparent_background_level > 0 and palette.none or ui.surface
    ),
    SnacksExplorerGitConflict = create(
      ui.error,
      config.transparent_background_level > 0 and palette.none or ui.surface,
      { styles.bold }
    ),
    SnacksExplorerSelection = create(ui.primary, palette.non, { styles.bold }),
    SnacksExplorerCursorLine = create(palette.none, ui.surface_variant),
    SnacksExplorerSearch = link("Search"),
    SnacksExplorerMatch = link("IncSearch"),
    SnacksExplorerEndOfBuffer = link("EndOfBuffer"),
    -- Icon colors in explorer (override default fallbacks)
    SnacksExplorerIcon = create(
      ui.on_surface_variant,
      config.transparent_background_level > 0 and palette.none or ui.surface
    ),

    ---------------------------------------------------------------------------
    -- Snacks Picker
    ---------------------------------------------------------------------------
    SnacksPickerNormal = create(ui.on_surface, float_bg),
    SnacksPickerBorder = create(ui.float_border, float_bg),
    SnacksPickerTitle = create(ui.float_title, float_bg, { styles.bold }),
    SnacksPickerPrompt = create(ui.on_surface, float_bg),
    SnacksPickerPromptPrefix = link("TelescopePromptPrefix"),
    SnacksPickerQuery = create(ui.primary, float_bg),
    SnacksPickerFilter = create(palette.secondary, float_bg),
    SnacksPickerSelection = create(ui.background, ui.selection),
    SnacksPickerMatch = create(ui.primary, palette.none, { styles.bold }),
    SnacksPickerList = create(ui.on_surface, float_bg),
    SnacksPickerCurrent = create(ui.primary, float_bg),
    SnacksPickerIndex = create(ui.on_surface, float_bg),
    SnacksPickerFooter = create(ui.on_surface, float_bg),
    SnacksPickerScrollbar = create(palette.none, float_bg),
    SnacksPickerScrollbarThumb = create(palette.none, ui.scrollbar_thumb),

    ---------------------------------------------------------------------------
    -- trouble.nvim
    ---------------------------------------------------------------------------
    TroubleNormal = create(ui.on_surface, config.transparent_background_level > 0 and palette.none or ui.surface),
    TroubleText = create(ui.on_surface, config.transparent_background_level > 0 and palette.none or ui.surface),
    TroubleFile = create(palette.secondary, config.transparent_background_level > 0 and palette.none or ui.surface),
    TroubleCount = create(ui.background, palette.tertiary, { styles.bold }),
    TroubleIndent = create(
      ui.on_surface_variant,
      config.transparent_background_level > 0 and palette.none or ui.surface_variant
    ),
    TroubleLocation = create(
      ui.on_surface_variant,
      config.transparent_background_level > 0 and palette.none or ui.surface_variant
    ),
    TroubleLineNumber = create(
      ui.primary,
      config.transparent_background_level > 0 and palette.none or ui.surface_variant
    ),
    TroubleFoldIcon = create(
      ui.on_surface_variant,
      config.transparent_background_level > 0 and palette.none or ui.surface_variant
    ),
    TroubleCode = create(ui.on_surface_variant, ui.surface_variant),
    TroublePreview = create(ui.on_surface, ui.surface_variant, { styles.bold }),
    TroubleSource = create(
      ui.on_surface_variant,
      config.transparent_background_level > 0 and palette.none or ui.surface_variant
    ),
    TroubleError = link("Red"),
    TroubleWarning = link("Yellow"),
    TroubleHint = link("Blue"),
    TroubleInformation = link("Green"),
    TroubleSignError = link("RedSign"),
    TroubleSignWarning = link("YellowSign"),
    TroubleSignHint = link("BlueSign"),
    TroubleSignInformation = link("GreenSign"),

    ---------------------------------------------------------------------------
    -- noice.nvim
    ---------------------------------------------------------------------------
    NoiceConfirm = create(ui.on_surface, float_bg),
    NoiceConfirmBorder = create(ui.float_border, float_bg),
    NoiceConfirmTitle = create(ui.float_title, float_bg, { styles.bold }),
    NoiceCmdline = create(ui.on_surface, float_bg),
    NoiceCmdlineIcon = create(palette.secondary, float_bg),
    NoiceCmdlinePopup = create(ui.on_surface, float_bg),
    NoiceCmdlinePopupBorder = create(ui.float_border, float_bg),
    NoiceCmdlinePrompt = create(ui.warn, float_bg),
    NoiceMini = create(ui.on_surface, float_bg),
    NoicePopup = create(ui.on_surface, float_bg),
    NoicePopupBorder = create(ui.float_border, float_bg),
    NoicePopupmenu = create(ui.on_surface, ui.popup_background),
    NoicePopupmenuBorder = create(ui.float_border, ui.popup_background),
    NoicePopupmenuSelected = create(ui.background, ui.selection),
    NoiceScrollbar = create(palette.none, float_bg),
    NoiceScrollbarThumb = create(palette.none, ui.scrollbar_thumb),
    NoiceVirtualText = create(ui.on_surface_variant, float_bg),
    NoiceFormatProgressDone = create(ui.success, float_bg),
    NoiceFormatProgressTodo = create(ui.on_surface_variant, float_bg),
    NoiceFormatProgressBar = create(ui.primary, float_bg),
    NoiceLspProgressSpinner = create(ui.warn, float_bg),
    NoiceLspProgressClient = create(palette.secondary, float_bg),
    NoiceLspProgressTitle = create(ui.primary, float_bg, { styles.bold }),
  }
end
