# Forest Flower

A Lua port of the [everforest](https://github.com/sainnhe/everforest) colour
scheme with customization.

> Recent breaking change: highlight definitions migrated to semantic role tables (`ui` & `syntax`). Direct `palette.*` usage in core has been reduced. Generic colour passthrough groups (Red, Green, etc.) remain intentionally for ecosystem compatibility.

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

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
require("lazy").setup({
  "YajanaRao/forestflower",
  version = false,
  lazy = false,
  priority = 1000,
})
```

## Inspiration

- [everforest](https://github.com/sainnhe/everforest) (obviously)
- [NeoSolarized.nvim](https://github.com/Tsuzat/NeoSolarized.nvim)
- [Tokyo Night](https://github.com/folke/tokyonight.nvim)
