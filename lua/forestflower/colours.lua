local M = {}

---@class MaterialTokens
---@field primary string
---@field primary_container string
---@field secondary string
---@field secondary_container string
---@field tertiary string
---@field tertiary_container string
---@field error string
---@field error_container string
---@field success string
---@field success_container string
---@field warning string
---@field warning_container string
---@field info string
---@field info_container string
---@field hint string
---@field hint_container string
---@field background string
---@field on_background string
---@field surface string
---@field on_surface string
---@field surface_variant string
---@field on_surface_variant string
---@field outline string
---@field outline_variant string
---@field none string

local palettes = {
  night = {
    primary = "#a7c080",
    primary_container = "#2d4d3a",
    secondary = "#7fbbb3",
    secondary_container = "#2d4d4a",
    tertiary = "#d699b6",
    tertiary_container = "#4d3d4a",
    error = "#eb6f92",
    error_container = "#4d2d3a",
    success = "#a7c080",
    success_container = "#2d4d3a",
    warning = "#f6c177",
    warning_container = "#4d4a2d",
    info = "#7fbbb3",
    info_container = "#2d4d4a",
    hint = "#9e9fb3",
    hint_container = "#3d4a4d",
    background = "#101010",
    on_background = "#a7c080",
    surface = "#1e2326",
    on_surface = "#a7c080",
    surface_variant = "#2d3338",
    on_surface_variant = "#596267",
    outline = "#353b40",
    outline_variant = "#3d4247",
    none = "NONE",
  },
  day = {
    primary = "#8da101",
    primary_container = "#e8f5d5",
    secondary = "#3a94c5",
    secondary_container = "#d5e8f5",
    tertiary = "#df69ba",
    tertiary_container = "#f5d5e8",
    error = "#f85552",
    error_container = "#f5d5d5",
    success = "#8da101",
    success_container = "#e8f5d5",
    warning = "#dfa000",
    warning_container = "#f5f0d5",
    info = "#3a94c5",
    info_container = "#d5e8f5",
    hint = "#6d8fb3",
    hint_container = "#e8edf5",
    background = "#fffbef",
    on_background = "#5c6a72",
    surface = "#f8f5e4",
    on_surface = "#5c6a72",
    surface_variant = "#edeada",
    on_surface_variant = "#9eac91",
    outline = "#c3cbb5",
    outline_variant = "#b1bca3",
    none = "NONE",
  },
}

---@return MaterialTokens
M.generate_palette = function(options, theme)
  local flavour = options.flavour or "night"
  local p = palettes[flavour]

  if options.colours_override then
    options.colours_override(p)
  end

  return p
end

---@class ForestflowerTheme
---@field palette MaterialTokens
---@field ui table
---@field syntax table
---@field status MaterialTokens
---@field ansi table

---@param p MaterialTokens
local function build_ui_roles(p)
  local ui = {
    background = p.background,
    surface = p.surface,
    surface_variant = p.surface_variant,
    border = p.outline_variant,
    outline = p.outline,
    primary = p.primary,
    primary_container = p.primary_container,
    success = p.success,
    success_container = p.success_container,
    info = p.info,
    info_container = p.info_container,
    warn = p.warning,
    warn_container = p.warning_container,
    error = p.error,
    error_container = p.error_container,
    hint = p.hint,
    hint_container = p.hint_container,
    git_add = p.success,
    git_change = p.warning,
    git_delete = p.error,
    fg = p.on_surface,
    fg_muted = p.on_surface_variant,
    fg_faint = p.on_surface_variant,
    float_background = p.surface,
    float_background_dim = p.surface_variant,
    float_border = p.outline,
    float_title = p.primary,
    popup_background = p.surface_variant,
    selection = p.primary_container,
    scrollbar_thumb = p.surface_variant,
    statusline_fg = p.on_surface,
    statusline_bg = p.surface_variant,
    statusline_nc_fg = p.on_surface_variant,
    statusline_nc_fg_alt = p.on_surface_variant,
    statusline_nc_bg = p.surface,
    tab_active_bg = p.surface_variant,
    tab_inactive_bg = p.surface,
    tab_inactive_fg = p.on_surface_variant,
    tab_fill_bg = p.background,
    tab_fill_fg = p.on_surface_variant,
  }

  return ui
end

local function build_syntax_roles(p, ui, opts)
  local comment_base = ui.fg_muted
  local syntax = {
    keyword = p.secondary,
    operator = p.on_surface_variant,
    ["function"] = p.primary,
    method = p.primary,
    type = p.tertiary,
    interface = p.tertiary,
    enum = p.secondary,
    constant = p.secondary_container,
    number = p.secondary_container,
    boolean = p.secondary_container,
    string = p.tertiary_container,
    variable = ui.fg,
    parameter = p.tertiary,
    property = p.primary,
    field = p.primary,
    namespace = p.tertiary,
    comment = comment_base,
    punctuation = p.on_surface_variant,
    macro = p.primary,
    special = p.primary_container,
    todo = p.warning,
    hint = ui.info,
    info = ui.info,
    warn = ui.warn,
    error = ui.error,
  }
  return syntax
end

local function build_ansi_roles(p)
  return {
    black = p.surface_variant,
    red = p.error,
    green = p.success,
    yellow = p.warning,
    blue = p.info,
    magenta = p.tertiary,
    cyan = p.secondary,
    white = p.on_surface,
  }
end

---@param options Config
---@param theme "light"|"dark"
---@return ForestflowerTheme
function M.get_theme(options, theme)
  local palette = M.generate_palette(options, theme)
  local ui = build_ui_roles(palette)
  local syntax = build_syntax_roles(palette, ui, options)
  local ansi = build_ansi_roles(palette)
  if options.roles_override then
    options.roles_override(ui)
  end
  if options.syntax_override then
    options.syntax_override(syntax)
  end
  return { palette = palette, ui = ui, syntax = syntax, status = palette, ansi = ansi }
end

M.build_ui_roles = build_ui_roles
M.build_syntax_roles = build_syntax_roles

return M
