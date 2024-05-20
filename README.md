# Everforest.nvim

A Lua port of the [everforest](https://github.com/sainnhe/everforest) colour
scheme.

||Dark|Light|
|:-:|:-:|:-:|
|**Hard**|![everforest colour scheme dark hard](https://github.com/neanias/everforest-nvim/assets/5786847/5a60315f-9311-4474-8a80-f2251344cc3a)|![eveforest colour scheme light hard](https://github.com/neanias/everforest-nvim/assets/5786847/acc83044-c9ec-4335-a1ab-2e5f3c9e7429)|
|**Medium** (default)|![eveforest colour scheme dark medium](https://github.com/neanias/everforest-nvim/assets/5786847/7094683a-1030-4cfe-b573-210f0b7863b1)|![everforest colour scheme light medium](https://github.com/neanias/everforest-nvim/assets/5786847/cccd5514-40ff-4155-b264-ceeba7b40ebf)|
|**Soft**|![everforest colour scheme dark soft](https://github.com/neanias/everforest-nvim/assets/5786847/affeb2a7-d934-4c55-a946-d03da01f389a)|![everforest colour scheme light soft](https://github.com/neanias/everforest-nvim/assets/5786847/570e23b2-0515-499b-a257-5a8afe80082e)|

_All screenshots taken from [my personal config](https://github.com/neanias/config/blob/main/nvim/lua/settings/plugins/everforest.lua)_

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

<details>
    <summary>The default configuration used by the colour scheme</summary>

```lua
require("everforest").setup({
  ---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
  ---Default is "medium".
  background = "medium",
  ---How much of the background should be transparent. 2 will have more UI
  ---components be transparent (e.g. status line background)
  transparent_background_level = 0,
  ---Whether italics should be used for keywords and more.
  italics = false,
  ---Disable italic fonts for comments. Comments are in italics by default, set
  ---this to `true` to make them _not_ italic!
  disable_italic_comments = false,
  ---By default, the colour of the sign column background is the same as the as normal text
  ---background, but you can use a grey background by setting this to `"grey"`.
  sign_column_background = "none",
  ---The contrast of line numbers, indent lines, etc. Options are `"high"` or
  ---`"low"` (default).
  ui_contrast = "low",
  ---Dim inactive windows. Only works in Neovim. Can look a bit weird with Telescope.
  ---
  ---When this option is used in conjunction with show_eob set to `false`, the
  ---end of the buffer will only be hidden inside the active window. Inside
  ---inactive windows, the end of buffer filler characters will be visible in
  ---dimmed symbols. This is due to the way Vim and Neovim handle `EndOfBuffer`.
  dim_inactive_windows = false,
  ---Some plugins support highlighting error/warning/info/hint texts, by
  ---default these texts are only underlined, but you can use this option to
  ---also highlight the background of them.
  diagnostic_text_highlight = false,
  ---Which colour the diagnostic text should be. Options are `"grey"` or `"coloured"` (default)
  diagnostic_virtual_text = "coloured",
  ---Some plugins support highlighting error/warning/info/hint lines, but this
  ---feature is disabled by default in this colour scheme.
  diagnostic_line_highlight = false,
  ---By default, this color scheme won't colour the foreground of |spell|, instead
  ---colored under curls will be used. If you also want to colour the foreground,
  ---set this option to `true`.
  spell_foreground = false,
  ---Whether to show the EndOfBuffer highlight.
  show_eob = true,
  ---Style used to make floating windows stand out from other windows. `"bright"`
  ---makes the background of these windows lighter than |hl-Normal|, whereas
  ---`"dim"` makes it darker.
  ---
  ---Floating windows include for instance diagnostic pop-ups, scrollable
  ---documentation windows from completion engines, overlay windows from
  ---installers, etc.
  ---
  ---NB: This is only significant for dark backgrounds as the light palettes
  ---have the same colour for both values in the switch.
  float_style = "bright",
  ---Inlay hints are special markers that are displayed inline with the code to
  ---provide you with additional information. You can use this option to customize
  ---the background color of inlay hints.
  ---
  ---Options are `"none"` or `"dimmed"`.
  inlay_hints_background = "none",
  ---You can override specific highlights to use other groups or a hex colour.
  ---This function will be called with the highlights and colour palette tables.
  ---@param highlight_groups Highlights
  ---@param palette Palette
  on_highlights = function(highlight_groups, palette) end,
  ---You can override colours in the palette to use different hex colours.
  ---This function will be called once the base and background colours have
  ---been mixed on the palette.
  ---@param palette Palette
  colours_override = function(palette) end,
})
```

</details>

## Overriding Highlight Groups

To find all possible palette colours, please see [`colours.lua`](lua/everforest/colours.lua).

For example, you could override the Diagnostic group of highlights to remove
the undercurl:

```lua
require("everforest").setup({
  on_highlights = function(hl, palette)
    hl.DiagnosticError = { fg = palette.none, bg = palette.none, sp = palette.red }
    hl.DiagnosticWarn = { fg = palette.none, bg = palette.none, sp = palette.yellow }
    hl.DiagnosticInfo = { fg = palette.none, bg = palette.none, sp = palette.blue }
    hl.DiagnosticHint = { fg = palette.none, bg = palette.none, sp = palette.green }
  end,
})
```

If you want to tweak or amend an existing highlight group you **need to add the
colours that aren't changing as well as your new styles**. This is because the
highlights defined in the `on_highlights` method will _override_ the default
highlights.

Here's an example of adding a **bold** styling to the `TSBoolean` highlight group:

```lua
require("everforest").setup({
  on_highlights = function(hl, palette)
    -- The default highlights for TSBoolean is linked to `Purple` which is fg
    -- purple and bg none. If we want to just add a bold style to the existing,
    -- we need to have the existing *and* the bold style. (We could link to
    -- `PurpleBold` here otherwise.)
    hl.TSBoolean = { fg = palette.purple, bg = palette.none, bold = true }
  end,
})
```

To clear any highlight groups, simply set them to `{}`:

```lua
require("everforest").setup({
  on_highlights = function(hl, palette)
    hl.TSDanger = {}
  end,
})
```

## Overriding colours in the palette

To find the existing palette colours, please see [`colours.lua`](lua/everforest/colours.lua).

For instance, if you use a dark background and want to use a darker hue for red,
you could use the following configuration:

```lua
require("everforest").setup({
  colours_override = function (palette)
    palette.red = "#b86466"
  end
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
  - [x] `dim_inactive_windows`
  - [x] `disable_italic_comments`
  - [x] `enable_italic` — this is `italic` in everforest-nvim
  - [ ] ~`cursor`~
  - [x] `sign_column_background`
  - [x] `spell_foreground`
  - [x] `ui_contrast`
  - [x] `show_eob`
  - [ ] `current_word`
  - [x] `diagnostic_text_highlight`
  - [x] `diagnostic_line_highlight`
  - [x] `diagnostic_virtual_text`
  - [ ] `disable_terminal_colours`
  - [x] `colours_override`
- [x] Transparent backgrounds
- [x] Different colour scheme "weights"

## Inspiration

- [everforest](https://github.com/sainnhe/everforest) (obviously)
- [NeoSolarized.nvim](https://github.com/Tsuzat/NeoSolarized.nvim)
- [Tokyo Night](https://github.com/folke/tokyonight.nvim)
