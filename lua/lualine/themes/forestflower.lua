local util = require("forestflower.util")
local config = require("forestflower").config

local palette = util.generate_palette(config, vim.o.background)

if config.transparent_background_level == 2 then
  palette.surface = palette.none
end

return {
  normal = {
    a = { bg = palette.primary, fg = palette.background, gui = "bold" },
    b = { bg = palette.outline, fg = palette.on_surface_variant },
    c = { bg = palette.surface, fg = palette.on_surface_variant },
  },
  insert = {
    a = { bg = palette.secondary, fg = palette.background, gui = "bold" },
    b = { bg = palette.outline, fg = palette.on_surface },
    c = { bg = palette.surface, fg = palette.on_surface },
  },
  visual = {
    a = { bg = palette.tertiary, fg = palette.background, gui = "bold" },
    b = { bg = palette.outline, fg = palette.on_surface },
    c = { bg = palette.surface, fg = palette.on_surface },
  },
  replace = {
    a = { bg = palette.warning, fg = palette.background, gui = "bold" },
    b = { bg = palette.outline, fg = palette.on_surface },
    c = { bg = palette.surface, fg = palette.on_surface },
  },
  command = {
    a = { bg = palette.secondary, fg = palette.background, gui = "bold" },
    b = { bg = palette.outline, fg = palette.on_surface },
    c = { bg = palette.surface, fg = palette.on_surface },
  },
  terminal = {
    a = { bg = palette.tertiary, fg = palette.background, gui = "bold" },
    b = { bg = palette.outline, fg = palette.on_surface },
    c = { bg = palette.surface, fg = palette.on_surface },
  },
  inactive = {
    a = { bg = palette.surface, fg = palette.on_surface_variant },
    b = { bg = palette.surface, fg = palette.on_surface_variant },
    c = { bg = palette.surface, fg = palette.on_surface_variant },
  },
}
