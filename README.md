# Everforest.nvim

A Lua port of the [everforest](https://github.com/sainnhe/everforest) colour
scheme. For screenshots, please see the everforest repo.

## Features

- 100% Lua, supports Treesitter & LSP
- Vim terminal colours
- **Lualine** theme

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
require("lazy").setup({
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require("everforest").setup({
      -- Your config here
    })
  end,
})
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use({
  "neanias/everforest-nvim",
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require("everforest").setup()
  end,
})
```

Using [vim-plug](https://github.com/junegunn/vim-plug):

```viml
Plug 'neanias/everforest-nvim', { 'branch': 'main' }
```

## Usage

```viml
" In VimL

" This has both light & dark modes to match your background setting.
colorscheme everforest
```

```lua
-- In Lua
vim.cmd([[colorscheme everforest]])

-- Alternatively
require("everforest").load()
```

To enable the everforest theme for LuaLine, you can specify it as such:

```lua
require("lualine").setup({
  options = {
    -- ... other configuration
    theme = "everforest", -- Can also be "auto" to detect automatically.
  }
})
```

### LspSaga information

Please note that LspSaga uses `Diagnostic{Warning,Error,Info,Hint}` highlight
groups to define its borders for diagnostic pop-ups, especially in
`diagnostic_jump_{next,prev}`. As discussed in the [Sonokai
repo](https://github.com/sainnhe/sonokai/issues/87), this is not a good idea
and there is no plan to change core highlights for one plugin.

**To prevent the problem of squiggly lines in LspSaga diagnostic windows,
please set the `diagnostic.border_follow` configuration option to `false`.**

## Configuration

> Configuration options aren't as comprehensive as the original everforest
> theme yet.

This colour scheme has a light and a dark mode which are configured using the
vim background setting: `:set background=light` or `vim.o.background=dark` as
appropriate.

This is the default config:

```lua
require("everforest").setup({
  -- Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
  -- Default is "medium".
  background = "medium",
  -- How much of the background should be transparent. Options are 0, 1 or 2.
  -- Default is 0.
  --
  -- 2 will have more UI components be transparent (e.g. status line
  -- background).
  transparent_background_level = 0,
  -- Whether italics should be used for keywords, builtin types and more.
  italics = false,
  -- Disable italic fonts for comments. Comments are in italics by default, set
  -- this to `true` to make them _not_ italic!
  disable_italic_comments = false,
})
```

## Plugin support

- [ALE](https://github.com/dense-analysis/ale)
- [Barbar](https://github.com/romgrk/barbar.nvim)
- [BufferLine](https://github.com/akinsho/nvim-bufferline.lua)
- [Coc.nvim](https://github.com/neoclide/coc.nvim)
- [Dashboard](https://github.com/glepnir/dashboard-nvim)
- [Git Gutter](https://github.com/airblade/vim-gitgutter)
- [Git Signs](https://github.com/lewis6991/gitsigns.nvim)
- [Hop](https://github.com/phaazon/hop.nvim)
- [Incline.nvim](https://github.com/b0o/incline.nvim)
- [Indent Blankline](https://github.com/lukas-reineke/indent-blankline.nvim)
- [LSP Diagnostics](https://neovim.io/doc/user/lsp.html)
- [LSP Saga](https://github.com/glepnir/lspsaga.nvim)
- [LSP Trouble](https://github.com/folke/lsp-trouble.nvim)
- [Leap](https://github.com/ggandor/leap.nvim)
- [Lualine](https://github.com/hoob3rt/lualine.nvim)
- [Mini](https://github.com/echasnovski/mini.nvim)
- [Neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [Neogit](https://github.com/TimUntersberger/neogit)
- [Neomake](https://github.com/neomake/neomake)
- [Neotest](https://github.com/nvim-neotest/neotest)
- [Noice](https://github.com/folke/noice.nvim)
- [NvimTree](https://github.com/nvim-tree/nvim-tree.lua)
- [Octo.nvim](https://github.com/pwntester/octo.nvim)
- [Scrollbar](https://github.com/petertriho/nvim-scrollbar)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [TreeSitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [Trouble](https://github.com/folke/trouble.nvim)
- [WhichKey](https://github.com/folke/which-key.nvim)
- [aerial.nvim](https://github.com/stevearc/aerial.nvim)
- [blamer.nvim](https://github.com/APZelos/blamer.nvim)
- [fzf.vim](https://github.com/junegunn/fzf.vim)
- [fsread.nvim](https://github.com/nullchilly/fsread.nvim)
- [lightspeed.nvim](https://github.com/ggandor/lightspeed.nvim)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
- [nvim-navic](https://github.com/SmiteshP/nvim-navic)
- [nvim-notify](https://github.com/rcarriga/nvim-notify)
- [nvim-ts-rainbow](https://github.com/p00f/nvim-ts-rainbow)
- [nvim-ts-rainbow2](https://github.com/HiPhish/nvim-ts-rainbow2)
- [packer.nvim](https://github.com/wbthomason/packer.nvim)
- [symbols-outline.nvim](https://github.com/simrat39/symbols-outline.nvim)
- [undotree](https://github.com/mbbill/undotree)
- [vim-floaterm](https://github.com/voldikss/vim-floaterm)
- [vim-matchup](https://github.com/andymass/vim-matchup)
- [vim-plug](https://github.com/junegunn/vim-plug)
- [vim-sneak](https://github.com/justinmk/vim-sneak)
- [yanky.nvim](https://github.com/gbprod/yanky.nvim)

See [the wiki](https://github.com/neanias/everforest-nvim/wiki) for the full
list of plugins that have highlights.

## Still TODO

- [ ] Colour scheme configuration
  - [x] `background`
  - [x] `transparent_background`
  - [ ] `dim_inactive_windows`
  - [x] `disable_italic_comments`
  - [x] `enable_italic`
  - [ ] ~`cursor`~
  - [ ] `sign_column_background`
  - [ ] `spell_foreground`
  - [ ] `ui_contrast`
  - [ ] `show_eob`
  - [ ] `current_word`
  - [ ] `diagnostic_text_highlight`
  - [ ] `diagnostic_line_highlight`
  - [ ] `diagnostic_virtual_text`
  - [ ] `disable_terminal_colours`
  - [ ] `colours_override`
- [x] Transparent backgrounds
- [x] Different colour scheme "weights"

## Inspiration

- [everforest](https://github.com/sainnhe/everforest) (obviously)
- [NeoSolarized.nvim](https://github.com/Tsuzat/NeoSolarized.nvim)
- [Tokyo Night](https://github.com/folke/tokyonight.nvim)
