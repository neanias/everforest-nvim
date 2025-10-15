local M = {}

local colors = require("forestflower.colours")

---@param c string
---@return table<number>
local function rgb(c)
  if not c or type(c) ~= "string" then
    -- return green default instead of black
    return { 0, 255, 0 }
  end
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---Blend two colors with alpha
---@param foreground string foreground color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
---@param background string background color
---@return string
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

---Blend color with background
---@param hex string
---@param amount number
---@param bg string
---@return string
function M.lighten(hex, amount, bg)
  local background = bg or "#ffffff"
  return M.blend(hex, amount, background)
end

---Blend color with foreground
---@param hex string
---@param amount number
---@param fg string
---@return string
function M.darken(hex, amount, fg)
  local foreground = fg or "#000000"
  return M.blend(hex, amount, foreground)
end

---Calculate contrast ratio between two colors
---@param a string @hex
---@param b string @hex
---@return number
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

---Audit contrast compliance for theme colors
---@param theme ForestflowerTheme
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
  classify("fg", theme.ui.fg, "critical")
  classify("fg_muted", theme.ui.fg_muted, "secondary")
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
---@param group string
---@param hl Highlight
function M.generate_highlight(group, hl)
  -- We can't add a highlight without a group
  if not group then
    return
  end

  vim.api.nvim_set_hl(0, group, hl)
end

---Generate multiple highlight groups
---@param syntax_entries Highlights
function M.generate_highlights(syntax_entries)
  for group, highlights in pairs(syntax_entries) do
    M.generate_highlight(group, highlights)
  end
end

---Load the colorscheme with terminal colors
---@param generated_syntax Highlights
---@param ansi table
function M.load(generated_syntax, ansi)
  if vim.g.colors_name then
    vim.cmd([[highlight clear]])
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "forestflower"

  -- Set terminal ANSI colors
  vim.g.terminal_color_0 = ansi.black
  vim.g.terminal_color_1 = ansi.red
  vim.g.terminal_color_2 = ansi.green
  vim.g.terminal_color_3 = ansi.yellow
  vim.g.terminal_color_4 = ansi.blue
  vim.g.terminal_color_5 = ansi.magenta
  vim.g.terminal_color_6 = ansi.cyan
  vim.g.terminal_color_7 = ansi.white

  M.generate_highlights(generated_syntax)
end

---Generate color palette
---@param options Config
---@param theme string
---@return MaterialTokens
function M.generate_palette(options, theme)
  local flavour = options.flavour or "night"
  local p = colors.palettes[flavour]

  if options.colours_override then
    options.colours_override(p)
  end

  return p
end

---Build UI role mappings
---@param p MaterialTokens
---@return table
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
    fg = p.on_surface,
    fg_muted = p.on_surface_variant,
    fg_faint = p.on_surface_variant,
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

---Build syntax role mappings
---@param p MaterialTokens
---@param ui table
---@param opts Config
---@return table
function M.build_syntax_roles(p, ui, opts)
  return syntax
end

---Build ANSI color mappings
---@param p MaterialTokens
---@return table
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

---Generate complete theme
---@param options Config
---@param theme string
---@return ForestflowerTheme
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
