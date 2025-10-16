---Terminal color system for Forest Flower colorscheme
---Handles ANSI terminal colors and external tool integrations

local util = require("forestflower.util")

---@class TerminalModule
local M = {}

---Configure terminal ANSI colors
---@param palette ColorPalette
---@param background string
function M.setup(palette, background)
  -- Base ANSI colors (0-7)
  vim.g.terminal_color_0 = palette.surface_variant
  vim.g.terminal_color_1 = palette.error
  vim.g.terminal_color_2 = palette.success
  vim.g.terminal_color_3 = palette.warning
  vim.g.terminal_color_4 = palette.info
  vim.g.terminal_color_5 = palette.tertiary
  vim.g.terminal_color_6 = palette.secondary
  vim.g.terminal_color_7 = palette.on_surface

  -- Bright ANSI colors (8-15)
  vim.g.terminal_color_8 = palette.outline_variant
  vim.g.terminal_color_9 = util.lighten(palette.error, 0.5)
  vim.g.terminal_color_10 = util.lighten(palette.success, 0.5)
  vim.g.terminal_color_11 = util.lighten(palette.warning, 0.5)
  vim.g.terminal_color_12 = util.lighten(palette.info, 0.5)
  vim.g.terminal_color_13 = util.lighten(palette.tertiary, 0.5)
  vim.g.terminal_color_14 = util.lighten(palette.secondary, 0.5)
  vim.g.terminal_color_15 = palette.on_surface       

  -- fzf.vim colors
  vim.g.fzf_colors = {
    fg = { "fg", "Normal" },
    bg = { "bg", "Normal" },
    hl = { "fg", "Green" },
    ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
    ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
    ["hl+"] = { "fg", "Aqua" },
    info = { "fg", "Aqua" },
    border = { "fg", "Grey" },
    prompt = { "fg", "Orange" },
    pointer = { "fg", "Blue" },
    marker = { "fg", "Yellow" },
    spinner = { "fg", "Yellow" },
    header = { "fg", "Grey" },
  }

  -- limelight.vim colors
  vim.g.limelight_conceal_ctermfg = palette.outline_variant
  vim.g.limelight_conceal_guifg = palette.outline_variant
end

return M

