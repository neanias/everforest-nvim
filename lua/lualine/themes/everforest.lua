local palettes = require("everforest.colours")
local palette

if vim.o.background == "dark" then
  palette = palettes.dark
else
  palette = palettes.light
end

return {
  normal = {
    a = { bg = palette.statusline1, fg = palette.bg0, gui = "bold" },
    b = { bg = palette.bg3, fg = palette.grey2 },
    c = { bg = palette.bg1, fg = palette.grey1 },
  },
  insert = {
    a = { bg = palette.statusline2, fg = palette.bg0, gui = "bold" },
    b = { bg = palette.bg3, fg = palette.fg },
    c = { bg = palette.bg1, fg = palette.fg },
  },
  visual = {
    a = { bg = palette.statusline3, fg = palette.bg0, gui = "bold" },
    b = { bg = palette.bg3, fg = palette.fg },
    c = { bg = palette.bg1, fg = palette.fg },
  },
  replace = {
    a = { bg = palette.orange, fg = palette.bg0, gui = "bold" },
    b = { bg = palette.bg3, fg = palette.fg },
    c = { bg = palette.bg1, fg = palette.fg },
  },
  command = {
    a = { bg = palette.aqua, fg = palette.bg0, gui = "bold" },
    b = { bg = palette.bg3, fg = palette.fg },
    c = { bg = palette.bg1, fg = palette.fg },
  },
  terminal = {
    a = { bg = palette.purple, fg = palette.bg0, gui = "bold" },
    b = { bg = palette.bg3, fg = palette.fg },
    c = { bg = palette.bg1, fg = palette.fg },
  },
  inactive = {
    a = { bg = palette.bg1, fg = palette.grey1 },
    b = { bg = palette.bg1, fg = palette.grey1 },
    c = { bg = palette.bg1, fg = palette.grey1 },
  },
}
