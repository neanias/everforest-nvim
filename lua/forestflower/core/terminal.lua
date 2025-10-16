---Terminal color system for Forest Flower colorscheme
---Handles ANSI terminal colors and external tool integrations

local util = require("forestflower.util")

---@class TerminalModule
local M = {}

---Configure terminal ANSI colors
---@param palette ColorPalette
---@param background string
function M.setup(palette, background)
  local terminal = {
    red = palette.error,
    yellow = palette.warning,
    green = palette.success,
    cyan = palette.secondary,
    blue = palette.info,
    purple = palette.tertiary,
  }

  if background == "dark" then
    terminal.black = palette.on_surface
    terminal.white = palette.outline
  else
    terminal.black = palette.outline
    terminal.white = palette.on_surface
  end

  -- Set ANSI colors
  vim.g.terminal_color_0 = terminal.black
  vim.g.terminal_color_8 = terminal.black
  vim.g.terminal_color_1 = terminal.red
  vim.g.terminal_color_9 = util.lighten(terminal.red, 0.5)
  vim.g.terminal_color_2 = terminal.green
  vim.g.terminal_color_10 = util.lighten(terminal.green, 0.5)
  vim.g.terminal_color_3 = terminal.yellow
  vim.g.terminal_color_11 = util.lighten(terminal.yellow, 0.5)
  vim.g.terminal_color_4 = terminal.blue
  vim.g.terminal_color_12 = util.lighten(terminal.blue, 0.5)
  vim.g.terminal_color_5 = terminal.purple
  vim.g.terminal_color_13 = util.lighten(terminal.purple, 0.5)
  vim.g.terminal_color_6 = terminal.cyan
  vim.g.terminal_color_14 = util.lighten(terminal.cyan, 0.5)
  vim.g.terminal_color_7 = terminal.white
  vim.g.terminal_color_15 = terminal.white

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

