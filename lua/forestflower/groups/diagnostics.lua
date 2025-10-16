---Diagnostic highlight groups
---LSP diagnostics, errors, warnings, etc.

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
    -- Diagnostic text
    DiagnosticError = create(palette.error, config.diagnostic_text_highlight and palette.error_container or palette.none),
    DiagnosticWarn = create(palette.warning, config.diagnostic_text_highlight and palette.warning_container or palette.none),
    DiagnosticInfo = create(palette.info, config.diagnostic_text_highlight and palette.info_container or palette.none),
    DiagnosticHint = create(palette.hint, config.diagnostic_text_highlight and palette.hint_container or palette.none),
    DiagnosticUnnecessary = create(ui.on_surface_variant, palette.none),
    
    -- Diagnostic virtual text
    DiagnosticVirtualTextError = link(config.diagnostic_virtual_text == "grey" and "Grey" or "Red"),
    DiagnosticVirtualTextWarn = link(config.diagnostic_virtual_text == "grey" and "Grey" or "Yellow"),
    DiagnosticVirtualTextInfo = link(config.diagnostic_virtual_text == "grey" and "Grey" or "Blue"),
    DiagnosticVirtualTextHint = link(config.diagnostic_virtual_text == "grey" and "Grey" or "Green"),
    
    -- Diagnostic underlines
    DiagnosticUnderlineError = create(palette.error, config.diagnostic_text_highlight and palette.error_container or palette.none, { styles.undercurl }, palette.error),
    DiagnosticUnderlineWarn = create(palette.warning, config.diagnostic_text_highlight and palette.warning_container or palette.none, { styles.undercurl }, palette.warning),
    DiagnosticUnderlineInfo = create(palette.info, config.diagnostic_text_highlight and palette.info_container or palette.none, { styles.undercurl }, palette.info),
    DiagnosticUnderlineHint = create(palette.success, config.diagnostic_text_highlight and palette.success_container or palette.none, { styles.undercurl }, palette.success),
    
    -- Diagnostic signs
    DiagnosticSignError = link("RedSign"),
    DiagnosticSignWarn = link("YellowSign"),
    DiagnosticSignInfo = link("BlueSign"),
    DiagnosticSignHint = link("GreenSign"),
    
    -- Diagnostic floating
    DiagnosticFloatingError = link("ErrorFloat"),
    DiagnosticFloatingWarn = link("WarningFloat"),
    DiagnosticFloatingInfo = link("InfoFloat"),
    DiagnosticFloatingHint = link("HintFloat"),
    
    -- Diagnostic lines
    ErrorLine = config.diagnostic_line_highlight and create(palette.none, palette.error_container) or {},
    WarningLine = config.diagnostic_line_highlight and create(palette.none, palette.warning_container) or {},
    InfoLine = config.diagnostic_line_highlight and create(palette.none, palette.info_container) or {},
    HintLine = config.diagnostic_line_highlight and create(palette.none, palette.hint_container) or {},
    
    -- LSP specific
    LspInlayHint = link("InlayHints"),
    LspReferenceText = link("CurrentWord"),
    LspReferenceRead = link("CurrentWord"),
    LspReferenceWrite = link("CurrentWord"),
    LspCodeLens = link("VirtualTextInfo"),
    LspCodeLensSeparator = link("VirtualTextHint"),
    LspSignatureActiveParameter = link("Search"),
    
    -- Health check
    healthError = link("Red"),
    healthSuccess = link("Green"),
    healthWarning = link("Yellow"),
  }
end

