local util = require("everforest.util")
local colours = require("everforest.colours")
local highlights = require("everforest.highlights")

local M = {}

M.config = {
  -- Controls the "hardness" of the background. Options are "light", "medium" or "hard".
  -- Default is "medium".
  background = "medium",
}

M.setup = function(opts)
  M.config = vim.tbl_extend("force", M.config, opts or {})
end

M.load = function()
  local palette = colours.generate_palette(M.config, vim.o.background)
  local generated_syntax = highlights.generate_syntax(palette)

  util.load(generated_syntax)
end

M.colorscheme = M.load

return M
