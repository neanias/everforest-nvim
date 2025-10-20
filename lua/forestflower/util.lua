---Utility functions for color manipulation and theme generation
---@class UtilModule
local M = {}

local colors = require("forestflower.core.colors")

---@enum HighlightStyles
M.styles = {
  bold = "bold",
  italic = "italic",
  reverse = "reverse",
  undercurl = "undercurl",
  underline = "underline",
  standout = "standout",
  strikethrough = "strikethrough",
  nocombine = "nocombine",
}

---Generates a highlight entry that can be accepted by nvim_set_hl
---@param fg string|nil Foreground color
---@param bg string|nil Background color
---@param stylings string[]|nil Array of style names (bold, italic, etc.)
---@param sp string|nil Special color (for undercurl, etc.)
---@return Highlight
function M.syntax_entry(fg, bg, stylings, sp)
  ---@type Highlight
  local highlight = {}

  if fg then
    highlight.fg = fg
  end

  if bg then
    highlight.bg = bg
  end

  if stylings then
    for _, style in ipairs(stylings) do
      if M.styles[style] then
        highlight[M.styles[style]] = true
      end
    end
  end

  if sp then
    highlight.sp = sp
  end

  return highlight
end

---Convert hex color string to RGB values
---@param c string Hex color string (e.g., "#ff0000")
---@return table<number> RGB values as {r, g, b}
local function rgb(c)
  if not c or type(c) ~= "string" then
    -- return green default instead of black
    return { 0, 255, 0 }
  end
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---Blend two colors with alpha
---@param foreground string Foreground color (hex)
---@param alpha number|string Alpha value between 0 and 1. 0 results in bg, 1 results in fg
---@param background string Background color (hex)
---@return string Blended color as hex string
function M.blend(foreground, alpha, background)
  alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
  local bg = rgb(background)
  local fg = rgb(foreground)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

---Blend color with background to lighten it
---@param hex string Color to lighten (hex)
---@param amount number Lightening amount (0-1)
---@param bg string|nil Background color (hex), defaults to white
---@return string Lightened color as hex string
function M.lighten(hex, amount, bg)
  local background = bg or "#ffffff"
  return M.blend(hex, amount, background)
end

---Blend color with foreground to darken it
---@param hex string Color to darken (hex)
---@param amount number Darkening amount (0-1)
---@param fg string|nil Foreground color (hex), defaults to black
---@return string Darkened color as hex string
function M.darken(hex, amount, fg)
  local foreground = fg or "#000000"
  return M.blend(hex, amount, foreground)
end

---Calculate contrast ratio between two colors
---@param a string First color (hex)
---@param b string Second color (hex)
---@return number Contrast ratio (1.0 = no contrast, 21.0 = maximum contrast)
function M.contrast(a, b)
  local function lum(hex)
    local r = tonumber(hex:sub(2, 3), 16) / 255
    local g = tonumber(hex:sub(4, 5), 16) / 255
    local function lin(c)
      if c <= 0.03928 then
        return c / 12.92
      else
        return ((c + 0.055) / 1.055) ^ 2.4
      end
    end
    r, g, b = lin(r), lin(g), lin(b)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b
  end
  local la, lb = lum(a), lum(b)
  if la < lb then
    la, lb = lb, la
  end
  return (la + 0.05) / (lb + 0.05)
end

---Audit contrast compliance for theme colors and report via vim.notify
---@param theme ForestflowerTheme Theme to audit
function M.contrast_audit(theme)
  local bg = theme.ui.background
  local critical_min = 4.5
  local secondary_min = 3.0
  local decorative_min = 2.5
  local classifications = {}
  local function classify(name, fg, tier)
    local ratio = M.contrast(fg, bg)
    local min = tier == "critical" and critical_min or (tier == "secondary" and secondary_min or decorative_min)
    local status
    if ratio >= min then
      status = "PASS"
    elseif tier == "decorative" then
      status = "WARN"
    else
      status = "FAIL"
    end
    table.insert(classifications, string.format("%-12s %s %5.2f %s", name, fg, ratio, status))
  end
  classify("on_surface", theme.ui.on_surface, "critical")
  classify("on_surface_variant", theme.ui.on_surface_variant, "secondary")
  classify("keyword", theme.syntax.keyword, "critical")
  classify("function", theme.syntax["function"], "critical")
  classify("string", theme.syntax.string, "critical")
  classify("number", theme.syntax.number, "critical")
  classify("comment", theme.syntax.comment, "decorative")
  vim.schedule(function()
    vim.notify("forestflower contrast audit:\n" .. table.concat(classifications, "\n"), vim.log.levels.INFO)
  end)
end

---Generate a single highlight group
---@param group string Highlight group name
---@param hl Highlight Highlight definition
function M.generate_highlight(group, hl)
  -- We can't add a highlight without a group
  if not group then
    return
  end

  vim.api.nvim_set_hl(0, group, hl)
end

---Generate multiple highlight groups
---@param syntax_entries Highlights Table of highlight group definitions
function M.generate_highlights(syntax_entries)
  for group, highlights in pairs(syntax_entries) do
    M.generate_highlight(group, highlights)
  end
end

---Load the colorscheme
---@param generated_syntax Highlights Generated highlight groups
---@param ansi table ANSI color mappings (kept for API compatibility)
function M.load(generated_syntax, ansi)
  if vim.g.colors_name then
    vim.cmd([[highlight clear]])
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "forestflower"

  -- Terminal colors are set by terminal.setup()
  M.generate_highlights(generated_syntax)
end

---Generate color palette from configuration
---@param options Config Configuration options
---@param theme string Theme name ("day" or "night")
---@return MaterialTokens Generated palette
function M.generate_palette(options, theme)
  local flavour = options.flavour or "night"
  local p = colors.palettes[flavour]

  if options.colours_override then
    options.colours_override(p)
  end

  return p
end

---Build UI role mappings from palette
---@param p MaterialTokens Color palette
---@return table UI role mappings
function M.build_ui_roles(p)
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
    on_surface = p.on_surface,
    on_surface_variant = p.on_surface_variant,
    -- removed fg_faint; use outline_variant where needed
    float_background = p.surface,
    float_background_dim = p.surface_variant,
    float_border = p.outline,
    float_title = p.primary,
    popup_background = p.surface_variant,
    -- Dedicated selection colour (was p.primary). Chosen muted green for neutrality.
    selection = "#4d6b5f",
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

-- Removed build_syntax_roles - was dead code that returned unused 'syntax' variable
-- Actual syntax colors come from colours.lua and are used via colors.syntax

---Build ANSI color mappings from palette
---@param p MaterialTokens Color palette
---@return table ANSI color mappings
function M.build_ansi_roles(p)
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

---@class ForestflowerTheme
---@field palette MaterialTokens
---@field ui table
---@field syntax table
---@field status MaterialTokens
---@field ansi table

---Generate complete theme from configuration
---@param options Config Configuration options
---@param theme string Theme name ("day" or "night")
---@return ForestflowerTheme Complete theme object
function M.get_theme(options, theme)
  local palette = M.generate_palette(options, theme)
  local ui = M.build_ui_roles(palette)
  local syntax = colors.syntax
  local ansi = M.build_ansi_roles(palette)
  if options.roles_override then
    options.roles_override(ui)
  end
  if options.syntax_override then
    options.syntax_override(syntax)
  end
  return { palette = palette, ui = ui, syntax = syntax, status = palette, ansi = ansi }
end

return M
