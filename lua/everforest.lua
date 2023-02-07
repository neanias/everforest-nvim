local util = require("everforest.util")
local colours = require("everforest.colours")
local highlights = require("everforest.highlights")

local M = {}

---@class Config
---@field background "soft" | "medium" | "hard"
---@field transparent_background_level 0 | 1 | 2
---@field italics boolean
---@field disable_italic_comments boolean
M.config = {
  -- Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
  -- Default is "medium".
  background = "medium",
  -- How much of the background should be transparent. 2 will have more UI
  -- components be transparent (e.g. status line background)
  transparent_background_level = 0,
  -- Whether italics should be used for keywords and more.
  italics = false,
  -- Disable italic fonts for comments. Comments are in italics by default, set
  -- this to `true` to make them _not_ italic!
  disable_italic_comments = false,
}

---@param opts Config | nil
M.setup = function(opts)
  M.config = vim.tbl_extend("force", M.config, opts or {})
end

M.load = function()
  local palette = colours.generate_palette(M.config, vim.o.background)
  local generated_syntax = highlights.generate_syntax(palette, M.config)

  util.load(generated_syntax)
end

M.colorscheme = M.load

return M
