-- AI related (Avante) separated
local util = require("forestflower.util")
return function(theme, options)
  local palette = theme.palette
  local function syntax_entry(fg, bg, stylings, sp)
    local h = { fg = fg, bg = bg }
    if stylings then for _, s in ipairs(stylings) do h[s] = true end end
    if sp then h.sp = sp end
    return h
  end
  local styles = { bold = "bold", italic = "italic", strikethrough = "strikethrough" }
  local t = {
    AvanteTitle = syntax_entry(palette.background, palette.success, { styles.bold }),
    AvanteReversedTitle = syntax_entry(palette.success, palette.none),
    AvanteSubtitle = syntax_entry(palette.background, palette.info, { styles.bold }),
    AvanteReversedSubtitle = syntax_entry(palette.info, palette.none),
    AvanteThirdTitle = syntax_entry(palette.on_surface, palette.surface_variant, { styles.bold }),
    AvanteReversedThirdTitle = syntax_entry(palette.surface_variant, palette.none),
    AvanteSuggestion = { link = "Comment" },
    AvanteAnnotation = { link = "Comment" },
    AvanteInlineHint = syntax_entry(palette.on_surface_variant, palette.none, { styles.italic }),
    AvantePopupHint = { link = "NormalFloat" },
    AvanteConflictCurrent = syntax_entry(palette.none, palette.error_container, { styles.bold }),
    AvanteConflictCurrentLabel = syntax_entry(util.darken(palette.error, 0.3), palette.error_container),
    AvanteConflictIncoming = syntax_entry(palette.none, palette.info_container, { styles.bold }),
    AvanteConflictIncomingLabel = syntax_entry(util.darken(palette.info, 0.3), palette.info_container),
    AvanteToBeDeleted = syntax_entry(palette.none, palette.error_container, { styles.strikethrough }),
    AvanteToBeDeletedWOStrikethrough = syntax_entry(palette.none, palette.error_container),
    AvanteButtonDefault = syntax_entry(palette.background, palette.on_surface_variant),
    AvanteButtonDefaultHover = syntax_entry(palette.background, palette.success),
    AvanteButtonPrimary = syntax_entry(palette.background, palette.info),
    AvanteButtonPrimaryHover = syntax_entry(palette.background, palette.secondary),
    AvanteButtonDanger = syntax_entry(palette.background, palette.error),
    AvanteButtonDangerHover = syntax_entry(palette.on_surface, palette.error),
    AvantePromptInput = syntax_entry(palette.on_surface, options.transparent_background_level > 0 and palette.none or palette.surface),
    AvantePromptInputBorder = { link = "NormalFloat" },
    AvanteConfirmTitle = syntax_entry(palette.background, palette.error, { styles.bold }),
    AvanteSidebarNormal = { link = "NormalFloat" },
    AvanteSidebarWinSeparator = { link = "WinSeparator" },
    AvanteSidebarWinHorizontalSeparator = syntax_entry(palette.outline_variant, options.transparent_background_level > 0 and palette.none or palette.surface),
    AvanteReversedNormal = syntax_entry(options.transparent_background_level > 0 and palette.none or palette.background, palette.on_surface),
    AvanteCommentFg = { link = "Comment" },
    AvanteStateSpinnerGenerating = syntax_entry(palette.background, palette.tertiary),
    AvanteStateSpinnerToolCalling = syntax_entry(palette.background, palette.info),
    AvanteStateSpinnerFailed = syntax_entry(palette.background, palette.error),
    AvanteStateSpinnerSucceeded = syntax_entry(palette.background, palette.success),
    AvanteStateSpinnerSearching = syntax_entry(palette.background, palette.warning),
    AvanteStateSpinnerThinking = syntax_entry(palette.background, palette.secondary),
    AvanteStateSpinnerCompacting = syntax_entry(palette.background, palette.warning),
    AvanteTaskRunning = syntax_entry(palette.tertiary, options.transparent_background_level > 0 and palette.none or palette.background),
    AvanteTaskCompleted = syntax_entry(palette.success, options.transparent_background_level > 0 and palette.none or palette.background),
    AvanteTaskFailed = syntax_entry(palette.error, options.transparent_background_level > 0 and palette.none or palette.background),
    AvanteThinking = syntax_entry(palette.secondary, options.transparent_background_level > 0 and palette.none or palette.background),
  }
  return t
end