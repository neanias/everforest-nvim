local util = {}

---@param group string
---@param hl Highlight
util.generate_highlight = function(group, hl)
  -- We can't add a highlight without a group
  if not group then
    return
  end

  vim.api.nvim_set_hl(0, group, hl)
end

---@param syntax_entries Highlights
util.generate_highlights = function(syntax_entries)
  for group, highlights in pairs(syntax_entries) do
    util.generate_highlight(group, highlights)
  end
end

---@param generated_syntax Highlights
util.load = function(generated_syntax)
  if vim.g.colors_name then
    vim.cmd([[highlight clear]])
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "forestflower"

  util.generate_highlights(generated_syntax)
end

---@param a string @hex
---@param b string @hex
function util.contrast(a,b)
  local function lum(hex)
    local r = tonumber(hex:sub(2,3),16)/255
    local g = tonumber(hex:sub(4,5),16)/255
    local b = tonumber(hex:sub(6,7),16)/255
    local function lin(c) if c <= 0.03928 then return c/12.92 else return ((c+0.055)/1.055)^2.4 end end
    r,g,b = lin(r),lin(g),lin(b)
    return 0.2126*r + 0.7152*g + 0.0722*b
  end
  local la, lb = lum(a), lum(b)
  if la < lb then la, lb = lb, la end
  return (la + 0.05)/(lb + 0.05)
end

---@param theme ForestflowerTheme
function util.contrast_audit(theme)
  local bg = theme.ui.background
  local critical_min = 4.5
  local secondary_min = 3.0
  local decorative_min = 2.5
  local classifications = {}
  local function classify(name, fg, tier)
    local ratio = util.contrast(fg, bg)
    local min = tier == 'critical' and critical_min or (tier == 'secondary' and secondary_min or decorative_min)
    local status
    if ratio >= min then
      status = 'PASS'
    elseif tier == 'decorative' then
      status = 'WARN'
    else
      status = 'FAIL'
    end
    table.insert(classifications, string.format('%-12s %s %5.2f %s', name, fg, ratio, status))
  end
  classify('fg', theme.ui.fg, 'critical')
  classify('fg_muted', theme.ui.fg_muted, 'secondary')
  classify('keyword', theme.syntax.keyword, 'critical')
  classify('function', theme.syntax['function'], 'critical')
  classify('string', theme.syntax.string, 'critical')
  classify('number', theme.syntax.number, 'critical')
  classify('comment', theme.syntax.comment, 'decorative')
  vim.schedule(function()
    vim.notify('forestflower contrast audit:\n' .. table.concat(classifications, '\n'), vim.log.levels.INFO)
  end)
end

return util
