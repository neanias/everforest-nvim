---@class Everforest.Util
local util = {}

util.generate_highlight = function(group, hl)
  -- We can't add a highlight without a group
  if not group then
    return
  end

  vim.api.nvim_set_hl(0, group, hl)
end

util.generate_highlights = function(syntax_entries)
  for group, highlights in pairs(syntax_entries) do
    util.generate_highlight(group, highlights)
  end
end

util.load = function(generated_syntax)
  if vim.g.colors_name then
    vim.cmd([[highlight clear]])
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "everforest"

  util.generate_highlights(generated_syntax)
end

return util
