-- main module file
local util = require("everforest.util")
local colours = require("everforest.colours")
local highlights = require("everforest.highlights")

local M = {}

M.config = {}

M.setup = function(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

M._load = function()
  local palette
  if vim.o.background == "dark" then
    palette = colours.dark
  else
    palette = colours.light
  end

  local generated_syntax = highlights.generate_syntax(palette)

  util.load(generated_syntax)
end

M.load = function()
  M._load()
end

M.colorscheme = M.load

return M
