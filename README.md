# Forest Flower

A Lua port of the [everforest](https://github.com/sainnhe/everforest) colour
scheme with customization.

## Design Philosophy & Identity

**Core Identity:** A nature-inspired colorscheme built around botanical greens and earthy tones, designed for extended coding sessions with reduced eye strain.

**Design Principles:**
- **Natural Palette:** Muted, forest-inspired greens (#b4d494 range) as primary accents—never electric or neon
- **Warm Neutrals:** Off-white text (#d3c6aa, #e6e1cf) on warm dark backgrounds for comfort during long sessions
- **Moderate Contrast:** Deliberately softer than pure black/white to reduce eye fatigue over 8+ hour workdays
- **Restrained Sophistication:** Earthy, calming tones over trendy, vibrant accents
- **Layered Surfaces:** Subtle depth through distinct background, surface, and surface_variant levels
- **Timeless over Trendy:** Resist chasing UI trends (Spotify green, Discord purple, etc.)

**Color Philosophy:**
- Greens evoke growth, focus, and nature
- Warm tones reduce harshness of pure grayscale
- Muted secondaries prevent visual competition with code
- Clear but gentle hierarchy in text and surface layers

**When Considering Changes:**
- Would this fit in a botanical garden or forest clearing?
- Does it maintain comfort for marathon coding sessions?
- Are we adding vibrancy or chasing trends?
- Does it preserve our earthy, sophisticated identity?

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
- **Enhanced React/JSX/TSX support** with distinct colors for components, attributes, and hooks

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

### Day and Night Variants

Forest Flower provides dedicated colorscheme variants for quick theme switching:

```lua
-- Switch to night theme (dark)
vim.cmd.colorscheme("forestflower-night")

-- Switch to day theme (light)
vim.cmd.colorscheme("forestflower-day")

-- Use default (respects config, defaults to night)
vim.cmd.colorscheme("forestflower")
```

These variants only override the flavour setting while preserving all other user configurations. This allows easy switching with the `:colorscheme` command or keybindings:

```lua
-- Example keybindings for theme switching
vim.keymap.set("n", "<leader>td", "<cmd>colorscheme forestflower-day<cr>", { desc = "Theme: Day" })
vim.keymap.set("n", "<leader>tn", "<cmd>colorscheme forestflower-night<cr>", { desc = "Theme: Night" })
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

### React/JSX/TSX Highlighting

Forest Flower provides enhanced syntax highlighting for React, JSX, and TSX with distinct colors for better visual differentiation:

**Visual Hierarchy:**

- 🔴 **React Components** (PascalCase): Coral `#dd7878` - Components like `<ChatWidget>`, `<Button>`
- 🔵 **HTML Tags** (lowercase): Cyan `#74c7ec` - Native elements like `<div>`, `<span>`
- 🟠 **JSX Attributes**: Orange `#f6c177` - Props like `onClick`, `className`, `css`
- 🟣 **React Hooks**: Purple `#c4a7e7` - `useState`, `useEffect`, `useCallback`
- 🟢 **Strings**: Green `#a7c080` - String values and text content

**Example:**

```tsx
import { useState } from "react"; // Hook import

const ChatWidget = ({ config }) => {
  // Component (coral)
  const [isOpen, setIsOpen] = useState(false); // Hook (purple)

  return (
    <FrameWrapper css={styles}>
      {" "}
      {/* Component (coral), Attribute (orange) */}
      <div className="container">
        {" "}
        {/* HTML tag (cyan), Attribute (orange) */}
        <ChatButton onClick={toggle}>
          {" "}
          {/* Component (coral), Attribute (orange) */}
          Open Chat {/* String (green) */}
        </ChatButton>
      </div>
    </FrameWrapper>
  );
};
```

This creates a clear visual hierarchy that makes React code easier to scan and understand at a glance.

### FAQ

Q: Treesitter highlight group names changed?
A: Forest Flower maps both legacy TS* groups and new *@\* captures; you can safely migrate gradually.

Q: Can I safely link to Red/Green groups?
A: Yes. These generic groups deliberately persist for plugin compatibility.

Q: Light mode?
A: Use `:colorscheme forestflower-day` for the light theme or `:colorscheme forestflower-night` for the dark theme. You can also set `flavour = "day"` in your config, or use `:set background=light` before loading.

Q: Soft background washed out with transparency?
A: Try `transparent_background_level = 1` only, or move to `medium` hardness.

## Inspiration

- [everforest](https://github.com/sainnhe/everforest) (obviously)
- [NeoSolarized.nvim](https://github.com/Tsuzat/NeoSolarized.nvim)
- [Tokyo Night](https://github.com/folke/tokyonight.nvim)
