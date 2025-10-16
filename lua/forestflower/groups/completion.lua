-- Completion related (cmp, blink, quick-scope, illuminate, etc.)
local util = require("forestflower.util")

return function(theme, options)
  local palette = theme.palette
  local ui = theme.ui
  local function syntax_entry(fg, bg, stylings)
    local h = { fg = fg, bg = bg }
    if stylings then for _, s in ipairs(stylings) do h[s] = true end end
    return h
  end
  local styles = { bold = "bold", italic = "italic", nocombine = "nocombine", underline = "underline" }

  local t = {
    -- nvim-cmp core
    CmpItemAbbrMatch = syntax_entry(palette.success, palette.none, { styles.bold }),
    CmpItemAbbrMatchFuzzy = syntax_entry(palette.success, palette.none, { styles.bold }),
    CmpItemAbbr = { link = "Fg" },
    CmpItemAbbrDeprecated = { link = "Grey" },
    CmpItemMenu = { link = "Fg" },
    CmpItemKind = { link = "Yellow" },
    -- Blink cmp additions
    BlinkCmpLabelMatch = syntax_entry(palette.none, palette.primary_container, { styles.bold }),
    BlinkCmpKind = { link = "Yellow" },
    -- Inline AI ghost suggestions
    CopilotSuggestion = syntax_entry(ui.primary, palette.error_container, { styles.italic, styles.nocombine }),
    ComplHint = syntax_entry(ui.on_surface_variant, palette.none, { styles.italic, styles.nocombine }),
    -- RRethy/vim-illuminate
    IlluminatedWordText = { link = "CurrentWord" },
    IlluminatedWordRead = { link = "CurrentWord" },
    IlluminatedWordWrite = { link = "CurrentWord" },
    -- quick-scope
    QuickScopePrimary = syntax_entry(palette.secondary, palette.none, { styles.underline }),
    QuickScopeSecondary = syntax_entry(palette.info, palette.none, { styles.underline }),
    -- vim_current_word
    CurrentWordTwins = { link = "CurrentWord" },
  }

  -- LSP kinds mapping reused for cmp / aerial / blink
  local lsp_kind_colours = {
    Array = "Aqua", Boolean = "Aqua", Class = "Yellow", Color = "Aqua", Constant = "Blue", Constructor = "Green",
    Default = "Aqua", Enum = "Yellow", EnumMember = "Purple", Event = "Orange", Field = "Green", File = "Green",
    Folder = "Aqua", Function = "Green", Interface = "Yellow", Key = "Red", Keyword = "Red", Method = "Green",
    Module = "Yellow", Namespace = "Purple", Null = "Aqua", Number = "Aqua", Object = "Aqua", Operator = "Orange",
    Package = "Purple", Property = "Blue", Reference = "Aqua", Snippet = "Aqua", String = "Aqua", Struct = "Yellow",
    Text = "Fg", TypeParameter = "Yellow", Unit = "Purple", Value = "Purple", Variable = "Blue",
  }
  for kind, colour in pairs(lsp_kind_colours) do
    t["CmpItemKind" .. kind] = { link = colour }
    t["Aerial" .. kind .. "Icon"] = { link = colour }
    t["BlinkCmpKind" .. kind] = { link = colour }
  end

  return t
end