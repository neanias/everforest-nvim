# Forest Flower

A Lua port of the [everforest](https://github.com/sainnhe/everforest) colour
scheme with customization.

|                      |                                                                  Dark                                                                  |                                                                  Light                                                                   |
| :------------------: | :------------------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------: |
|       **Hard**       |        ![forestflower colour scheme dark hard](https://github.com/user-attachments/assets/1174661f-2de3-4dd2-8e2f-6ee3df8afb9c)        |  ![eveforest colour scheme light hard](https://github.com/neanias/everforest-nvim/assets/5786847/acc83044-c9ec-4335-a1ab-2e5f3c9e7429)   |
| **Medium** (default) | ![eveforest colour scheme dark medium](https://github.com/neanias/everforest-nvim/assets/5786847/7094683a-1030-4cfe-b573-210f0b7863b1) | ![everforest colour scheme light medium](https://github.com/neanias/everforest-nvim/assets/5786847/cccd5514-40ff-4155-b264-ceeba7b40ebf) |
|       **Soft**       | ![everforest colour scheme dark soft](https://github.com/neanias/everforest-nvim/assets/5786847/affeb2a7-d934-4c55-a946-d03da01f389a)  |  ![everforest colour scheme light soft](https://github.com/neanias/everforest-nvim/assets/5786847/570e23b2-0515-499b-a257-5a8afe80082e)  |

_All screenshots taken from [my personal config](https://github.com/YajanaRao/kickstart.nvim)_

## Features

- 100% Lua, supports Treesitter & LSP
- Vim terminal colours
- **Lualine** theme

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim) (basic):

```lua
require("lazy").setup({
  {
    "YajanaRao/forestflower",
    priority = 1000, -- load first so everything can inherit
    lazy = false,    -- force load during startup
    opts = {         -- override any default (all shown below)
      background = "medium", -- "soft" | "medium" | "hard"
      transparent_background_level = 0, -- 0 | 1 | 2
      italics = false,
      disable_italic_comments = false,
      sign_column_background = "none", -- "none" | "grey"
      diagnostic_text_highlight = false,
      diagnostic_virtual_text = "coloured", -- "coloured" | "grey"
      diagnostic_line_highlight = false,
      show_eob = true,
      float_style = "bright", -- "bright" | "dim"
      contrast_audit = false,
      on_highlights = function(hl, palette) end,
      colours_override = function(p) end,
    },
    config = function(_, opts)
      require("forestflower").setup(opts)
      vim.cmd.colorscheme("forestflower")
    end,
  },
})
```

### LazyVim specific

If you are using LazyVim and want this to be your colorscheme, create (or edit) a spec file:

```lua
-- lua/plugins/colorscheme.lua
return {
  {
    "YajanaRao/forestflower",
    priority = 1000,
    lazy = false,
    opts = { background = "medium" },
    config = function(_, opts)
      require("forestflower").setup(opts)
      vim.cmd.colorscheme("forestflower")
    end,
  },
}
```

### Minimal setup

```lua
vim.cmd.colorscheme("forestflower")
```

### Options

| Option                       | Type     | Default    | Description                                                        |
| ---------------------------- | -------- | ---------- | ------------------------------------------------------------------ |
| background                   | string   | "medium"   | Hardness of base background: "soft", "medium", "hard"              |
| transparent_background_level | integer  | 0          | 0: normal, 1: editor bg transparent, 2: more UI chrome transparent |
| italics                      | boolean  | false      | Enable italics for keywords etc.                                   |
| disable_italic_comments      | boolean  | false      | Force comments non-italic                                          |
| sign_column_background       | string   | "none"     | "none" or "grey" background for sign column                        |
| diagnostic_text_highlight    | boolean  | false      | Fill diagnostic virtual text background                            |
| diagnostic_virtual_text      | string   | "coloured" | "coloured" or "grey" diagnostic virtual text colour                |
| diagnostic_line_highlight    | boolean  | false      | Background highlight for entire diagnostic lines                   |
| show_eob                     | boolean  | true       | Show end-of-buffer tildes                                          |
| float_style                  | string   | "bright"   | Floating win bg lighter ("bright") or darker ("dim")               |
| contrast_audit               | boolean  | false      | Run contrast audit and report via vim.notify                       |
| on_highlights                | function | noop       | (hl, palette) mutate final highlight groups                        |
| colours_override             | function | noop       | (palette) edit raw material-ish tokens before roles applied        |

### Override examples

Darken selection, tweak palette & add custom group.

```lua
require("forestflower").setup({
  colours_override = function(p)
    p.primary = "#98c379" -- change primary accent
  end,
  on_highlights = function(hl, palette)
    hl.MyTitle = { fg = palette.primary, bold = true }
    hl.MySelection = { bg = "#445566" } -- custom selection bg
  end,
})
vim.cmd.colorscheme("forestflower")
```

### Contrast audit

Enable `contrast_audit = true` to receive a summary of WCAG-ish contrast ratios for core roles. Useful while theming or adjusting roles.

### FAQ

Q: Treesitter highlight group names changed?
A: Forest Flower maps both legacy TS* groups and new *@\* captures; you can safely migrate gradually.

Q: Can I safely link to Red/Green groups?
A: Yes. These generic groups deliberately persist for plugin compatibility.

Q: Light mode?
A: Set `:set background=light` before loading the colourscheme (palettes implement both day & night). You may also set `flavour = "day"` soon (planned prop alignment).

Q: Soft background washed out with transparency?
A: Try `transparent_background_level = 1` only, or move to `medium` hardness.

## Inspiration

- [everforest](https://github.com/sainnhe/everforest) (obviously)
- [NeoSolarized.nvim](https://github.com/Tsuzat/NeoSolarized.nvim)
- [Tokyo Night](https://github.com/folke/tokyonight.nvim)
