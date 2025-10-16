---Forest Flower Colorscheme
---A modern, well-organized Lua colorscheme with proper separation of concerns

local theme_builder = require("forestflower.core.theme")
local highlights = require("forestflower.core.highlights")
local terminal = require("forestflower.core.terminal")
local util = require("forestflower.util")

---@alias Highlight vim.api.keyset.highlight
---@alias Highlights table<string,Highlight>
---@alias ColorPalette table

---@class Config
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

local M = {}

---Default configuration
M.config = {
  flavour = "night",
  background = "medium",
  transparent_background_level = 0,
  italics = false,
  disable_italic_comments = false,
  sign_column_background = "none",
  diagnostic_text_highlight = false,
  diagnostic_virtual_text = "coloured",
  diagnostic_line_highlight = false,
  show_eob = true,
  float_style = "bright",
  on_highlights = function() end,
  colours_override = function() end,
  contrast_audit = false,
}

---Setup colorscheme configuration
---@param opts Config|nil
function M.setup(opts)
  M.config = vim.tbl_extend("force", M.config, opts or {})
end

---Load highlight groups from modules
---@param theme ForestflowerTheme
---@param config Config
---@return Highlights
local function load_highlight_groups(theme, config)
  local all_highlights = {}
  
  -- Load base colors first
  local base_colors = highlights.create_base_colors(theme.palette, highlights.styles)
  for name, highlight in pairs(base_colors) do
    all_highlights[name] = highlight
  end
  
  -- Load highlight group modules
  local modules = {
    "forestflower.groups.editor",
    "forestflower.groups.syntax", 
    "forestflower.groups.diagnostics",
    "forestflower.groups.plugins",
  }
  
  for _, module_name in ipairs(modules) do
    local ok, module = pcall(require, module_name)
    if ok and type(module) == "function" then
      local module_highlights = module(theme, config)
      for name, highlight in pairs(module_highlights) do
        all_highlights[name] = highlight
      end
    end
  end
  
  return all_highlights
end

---Load the colorscheme
function M.load()
  local theme = theme_builder.build(M.config, vim.o.background)
  local highlight_groups = load_highlight_groups(theme, M.config)
  
  -- Run contrast audit if enabled
  if M.config.contrast_audit then
    util.contrast_audit(theme)
  end
  
  -- Setup terminal colors
  terminal.setup(theme.palette, vim.o.background)
  
  -- Apply highlights
  util.load(highlight_groups, theme.ansi)
  
  -- Allow user overrides
  if M.config.on_highlights then
    M.config.on_highlights(highlight_groups, theme.palette)
  end
end

---Alias for load function
M.colorscheme = M.load

return M

