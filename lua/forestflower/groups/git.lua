-- Git related (gitsigns, diff, gitcommit, blame)
return function(theme, options)
  local palette, status = theme.palette, theme.status
  local function syntax_entry(fg, bg, stylings)
    local h = { fg = fg, bg = bg }
    if stylings then for _, s in ipairs(stylings) do h[s] = true end end
    return h
  end

  return {
    DiffAdd = syntax_entry(palette.none, status.success_container),
    DiffChange = syntax_entry(palette.none, status.info_container),
    DiffDelete = syntax_entry(palette.none, status.error_container),
    DiffText = syntax_entry(theme.ui.background, theme.ui.primary),
    diffAdded = { link = "Added" },
    diffRemoved = { link = "Removed" },
    diffChanged = { link = "Changed" },
    diffOldFile = { link = "Yellow" },
    diffNewFile = { link = "Orange" },
    diffFile = { link = "Aqua" },
    diffLine = { link = "Grey" },
    diffIndexLine = { link = "Purple" },
    GitSignsAdd = { link = "GreenSign" },
    GitSignsChange = { link = "BlueSign" },
    GitSignsDelete = { link = "RedSign" },
    GitSignsAddNr = { link = "Green" },
    GitSignsChangeNr = { link = "Blue" },
    GitSignsDeleteNr = { link = "Red" },
    GitSignsAddLn = { link = "DiffAdd" },
    GitSignsChangeLn = { link = "DiffChange" },
    GitSignsDeleteLn = { link = "DiffDelete" },
    GitSignsCurrentLineBlame = { link = "Grey" },
    Blamer = { link = "Grey" },
    gitcommitSummary = { link = "Green" },
    gitcommitUntracked = { link = "Grey" },
    gitcommitDiscarded = { link = "Grey" },
    gitcommitSelected = { link = "Grey" },
    gitcommitUnmerged = { link = "Grey" },
    gitcommitOnBranch = { link = "Grey" },
    gitcommitArrow = { link = "Grey" },
    gitcommitFile = { link = "Green" },
  }
end