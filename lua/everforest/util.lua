local util = {}

util.highlight = function(group, hl)
  -- We can't add a highlight without a group
  if not group then
    return
  end

  vim.api.nvim_set_hl(0, group, hl)

  if hl.link then
    vim.cmd(string.format("highlight! link %s %s", group, hl.link))
  end
end

util.syntax = function(syntax_entries)
  for group, highlights in pairs(syntax_entries) do
    util.highlight(group, highlights)
  end
end

util.load = function(generated_syntax)
  if vim.g.colors_name then
    vim.cmd([[highlight clear]])
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "everforest"

  util.syntax(generated_syntax)
end

return util
