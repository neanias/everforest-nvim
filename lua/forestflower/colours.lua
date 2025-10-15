local M = {}

---@class PaletteBackground
---@field bg_dim string
---@field bg0 string
---@field bg1 string
---@field bg2 string
---@field bg3 string
---@field bg4 string
---@field bg5 string
---@field bg_visual string
---@field bg_red string
---@field bg_green string
---@field bg_blue string
---@field bg_yellow string

---@class PaletteBase
---@field fg string
---@field red string
---@field orange string
---@field yellow string
---@field green string
---@field aqua string
---@field blue string
---@field purple string
---@field grey0 string
---@field grey1 string
---@field grey2 string
---@field statusline1 string
---@field statusline2 string
---@field statusline3 string
---@field none string

---@class Palette: PaletteBase,PaletteBackground

---@alias Backgrounds "light" | "dark"
---@alias PaletteBackgrounds table<Backgrounds, PaletteBackground>

---@type PaletteBackgrounds
local hard_background = {
  night = {
    bg0 = "#101010",
    bg_dim = "#141616",
    bg1 = "#1e2326",
    bg2 = "#252b30",
    bg3 = "#2d3338",
    bg4 = "#353b40",
    bg5 = "#3d4247",
    bg_visual = "#293037",
    bg_red = "#2a1d21",
    bg_green = "#1f2b23",
    bg_blue = "#1f3035",
    bg_yellow = "#302d24",
  },
  day = {
    bg_dim = "#f2efdf",
    bg0 = "#fffbef",
    bg1 = "#f8f5e4",
    bg2 = "#f2efdf",
    bg3 = "#edeada",
    bg4 = "#e8e5d5",
    bg5 = "#bec5b2",
    bg_visual = "#dde5b6",
    -- bg_visual = "#f0f2d4",
    bg_red = "#ffe7de",
    bg_green = "#f3f5d9",
    bg_blue = "#ecf5ed",
    bg_yellow = "#fef2d5",
  },
}

---@type table<Backgrounds, PaletteBase>
local base_palette = {
  day = {
    fg = "#5c6a72",
    red = "#f85552",
    orange = "#f57d26",
    yellow = "#dfa000",
    green = "#8da101",
    aqua = "#35a77c",
    blue = "#3a94c5",
    purple = "#df69ba",
    grey0 = "#a6b0a0",
    grey1 = "#939f91",
    grey2 = "#829181",
    statusline1 = "#93b259",
    statusline2 = "#708089",
    statusline3 = "#e66868",
    none = "NONE",
  },
  night = {
    fg = "#d3c6aa",
    red = "#eb6f92",
    orange = "#e69875",
    yellow = "#f6c177",
    green = "#a7c080",
    aqua = "#83c092",
    blue = "#7fbbb3",
    purple = "#d699b6",
    grey0 = "#7a8478",
    grey1 = "#859289",
    grey2 = "#9da9a0",
    statusline1 = "#a6e3a1",
    statusline2 = "#89b4fa",
    statusline3 = "#e67e80",
    none = "NONE",
  },
}

---Generates the colour palette based on the user's config
---@param options Config The package configuration table
---@param theme "light" | "dark" The user's background preference
---@return Palette
M.generate_palette = function(options, theme)
  local flavour = options.flavour or "night"
  local base = base_palette[flavour]
  ---@type PaletteBackground
  local background_palette = hard_background[flavour]

  ---@type Palette
  local combined_palette = vim.tbl_extend("force", base, background_palette)
  options.colours_override(combined_palette)

  return combined_palette
end

---@class ForestflowerTheme
---@field palette Palette
---@field ui table
---@field syntax table

local function luminance(hex)
  local r = tonumber(hex:sub(2,3),16)/255
  local g = tonumber(hex:sub(4,5),16)/255
  local b = tonumber(hex:sub(6,7),16)/255
  local function lin(c)
    if c <= 0.03928 then return c/12.92 else return ((c+0.055)/1.055)^2.4 end
  end
  r,g,b = lin(r),lin(g),lin(b)
  return 0.2126*r + 0.7152*g + 0.0722*b
end

local function contrast(a,b)
  local la, lb = luminance(a), luminance(b)
  if la < lb then la, lb = lb, la end
  return (la + 0.05) / (lb + 0.05)
end

---@param p Palette
---@param opts Config
local function build_ui_roles(p, opts)
  local ui = {
    background = p.bg0,
    background_alt = p.bg1,
    surface = p.bg2,
    surface_muted = p.bg3,
    surface_highlight = p.bg_visual,
    border = p.bg4,
    outline = p.bg5,
    primary = p.green,
    primary_container = p.bg_green,
    success = p.green,
    info = p.blue,
    warn = p.yellow,
    error = p.red,
    git_add = p.green,
    git_change = p.orange,
    git_delete = p.red,
    fg = p.fg,
    fg_muted = p.grey1,
    fg_faint = p.grey0,
    -- Added role-based UI extensions
    float_background = p.bg2,
    float_background_dim = p.bg_dim,
    float_border = p.bg4,
    float_title = p.green,
    popup_background = p.bg1,
    selection = p.bg_visual,
    scrollbar_thumb = p.bg3,
    statusline_fg = p.fg,
    statusline_bg = p.bg2,
    statusline_nc_fg = p.grey1,
    statusline_nc_fg_alt = p.grey0,
    statusline_nc_bg = p.bg1,
    tab_active_bg = p.bg2,
    tab_inactive_bg = p.bg1,
    tab_inactive_fg = p.grey1,
    tab_fill_bg = p.bg0,
    tab_fill_fg = p.grey0,
  }

  -- Basic contrast enforcement (optional, soft)
  local min_text = 4.5
  local min_muted = 3.5
  if contrast(ui.fg, ui.background) < min_text then
    ui.fg = p.grey2 -- fallback brighter neutral
  end
  if contrast(ui.fg_muted, ui.background) < min_muted then
    ui.fg_muted = p.grey2
  end
  return ui
end

---@param p Palette
---@param ui table
---@param opts Config
local function blend(fg, bg, alpha)
  local function ch(hex, i) return tonumber(hex:sub(i,i+1),16) end
  local r1,g1,b1 = ch(fg,2), ch(fg,4), ch(fg,6)
  local r2,g2,b2 = ch(bg,2), ch(bg,4), ch(bg,6)
  local r = math.floor(r1*(1-alpha) + r2*alpha + 0.5)
  local g = math.floor(g1*(1-alpha) + g2*alpha + 0.5)
  local b = math.floor(b1*(1-alpha) + b2*alpha + 0.5)
  return string.format('#%02x%02x%02x', r,g,b)
end

local function build_syntax_roles(p, ui, opts)
  local comment_base = ui.fg_muted
  if opts.dim_comments then
    comment_base = blend(comment_base, ui.background, opts.dim_intensity or 0.35)
  end
  local syntax = {
    keyword = p.orange,
    operator = p.grey2,
    ["function"] = p.green,
    method = p.green,
    type = p.blue,
    interface = p.blue,
    enum = p.purple,
    constant = p.yellow,
    number = p.yellow,
    boolean = p.yellow,
    string = p.aqua, -- separated from function (green)
    variable = ui.fg,
    parameter = p.aqua,
    property = p.blue,
    field = p.blue,
    namespace = p.purple,
    comment = comment_base,
    punctuation = p.grey2,
    macro = p.purple,
    special = p.purple,
    todo = p.yellow,
    hint = ui.info,
    info = ui.info,
    warn = ui.warn,
    error = ui.error,
  }
  return syntax
end

---@param options Config
---@param theme "light"|"dark"
---@return ForestflowerTheme
function M.get_theme(options, theme)
  local palette = M.generate_palette(options, theme)
  local ui = build_ui_roles(palette, options)
  local syntax = build_syntax_roles(palette, ui, options)
  if options.roles_override then options.roles_override(ui) end
  if options.syntax_override then options.syntax_override(syntax) end
  return { palette = palette, ui = ui, syntax = syntax }
end

M.build_ui_roles = build_ui_roles
M.build_syntax_roles = build_syntax_roles

return M
