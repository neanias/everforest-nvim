---Theme builder for Forest Flower colorscheme
---Builds complete theme objects from color palettes and configuration

local colors = require("forestflower.core.colors")
local util = require("forestflower.util")

---@class ThemeConfig
---@field flavour "day" | "night"
---@field background "soft" | "medium" | "hard"
---@field transparent_background_level 0 | 1 | 2
---@field italics boolean
---@field disable_italic_comments boolean
---@field sign_column_background "none" | "grey"
---@field diagnostic_text_highlight boolean
---@field diagnostic_virtual_text "coloured" | "grey"
---@field diagnostic_line_highlight boolean
---@field show_eob boolean
---@field float_style "bright" | "dim"
---@field on_highlights fun(highlight_groups: Highlights, palette: ColorPalette)
---@field colours_override fun(palette: ColorPalette)
---@field contrast_audit boolean

---@class ForestflowerTheme
---@field palette ColorPalette
---@field ui table
---@field syntax SyntaxTokens
---@field ansi table

local M = {}

---Build UI role mappings from palette
---@param palette ColorPalette
---@return table
local function build_ui_roles(palette)
  return {
    background = palette.background,
    surface = palette.surface,
    surface_variant = palette.surface_variant,
    border = palette.outline_variant,
    outline = palette.outline,
    primary = palette.primary,
    primary_container = palette.primary_container,
    success = palette.success,
    success_container = palette.success_container,
    info = palette.info,
    info_container = palette.info_container,
    warn = palette.warning,
    warn_container = palette.warning_container,
    error = palette.error,
    error_container = palette.error_container,
    hint = palette.hint,
    hint_container = palette.hint_container,
    git_add = palette.success,
    git_change = palette.warning,
    git_delete = palette.error,
    fg = palette.on_surface,
    fg_muted = palette.on_surface_variant,
    fg_faint = palette.on_surface_variant,
    float_background = palette.surface,
    float_background_dim = palette.surface_variant,
    float_border = palette.outline,
    float_title = palette.primary,
    popup_background = palette.surface_variant,
    selection = palette.primary_container,
    scrollbar_thumb = palette.surface_variant,
    statusline_fg = palette.on_surface,
    statusline_bg = palette.surface_variant,
    statusline_nc_fg = palette.on_surface_variant,
    statusline_nc_fg_alt = palette.on_surface_variant,
    statusline_nc_bg = palette.surface,
    tab_active_bg = palette.surface_variant,
    tab_inactive_bg = palette.surface,
    tab_inactive_fg = palette.on_surface,
    tab_fill_bg = palette.background,
    tab_fill_fg = palette.on_surface_variant,
  }
end

---Build ANSI color mappings
---@param palette ColorPalette
---@return table
local function build_ansi_roles(palette)
  return {
    black = palette.surface_variant,
    red = palette.error,
    green = palette.success,
    yellow = palette.warning,
    blue = palette.info,
    magenta = palette.tertiary,
    cyan = palette.secondary,
    white = palette.on_surface,
  }
end

---Generate complete theme from configuration
---@param config ThemeConfig
---@param background string
---@return ForestflowerTheme
function M.build(config, background)
  local flavour = config.flavour or "night"
  local palette = colors.palettes[flavour]
  
  -- Apply color overrides
  if config.colours_override then
    config.colours_override(palette)
  end
  
  local ui = build_ui_roles(palette)
  local syntax = colors.syntax
  local ansi = build_ansi_roles(palette)
  
  
  return {
    palette = palette,
    ui = ui,
    syntax = syntax,
    ansi = ansi,
  }
end

return M

