-- module represents a lua module for the plugin
local M = {}

local hard_background = {
  dark = {
    bg0 = "#2b3339",
    bg1 = "#323c41",
    bg2 = "#3a454a",
    bg3 = "#445055",
    bg4 = "#4c555b",
    bg5 = "#53605c",
    bg_visual = "#503946",
    bg_red = "#4e3e43",
    bg_green = "#404d44",
    bg_blue = "#394f5a",
    bg_yellow = "#4a4940",
  },
  light = {
    bg0 = "#fff9e8",
    bg1 = "#f7f4e0",
    bg2 = "#f0eed9",
    bg3 = "#e9e8d2",
    bg4 = "#e1ddcb",
    bg5 = "#bec5b2",
    bg_visual = "#edf0cd",
    bg_red = "#fce5dc",
    bg_green = "#f1f3d4",
    bg_blue = "#eaf2eb",
    bg_yellow = "#fbefd0",
  },
}

local medium_background = {
  dark = {
    bg0 = "#2f383e",
    bg1 = "#374247",
    bg2 = "#404c51",
    bg3 = "#4a555b",
    bg4 = "#525c62",
    bg5 = "#596763",
    bg_visual = "#573e4c",
    bg_red = "#544247",
    bg_green = "#445349",
    bg_blue = "#3b5360",
    bg_yellow = "#504f45",
  },
  light = {
    bg0 = "#fdf6e3",
    bg1 = "#f3efda",
    bg2 = "#edead5",
    bg3 = "#e4e1cd",
    bg4 = "#dfdbc8",
    bg5 = "#bdc3af",
    bg_visual = "#eaedc8",
    bg_red = "#fbe3da",
    bg_green = "#f0f1d2",
    bg_blue = "#e9f0e9",
    bg_yellow = "#faedcd",
  },
}

local light_background = {
  dark = {
    bg0 = "#323d43",
    bg1 = "#3c474d",
    bg2 = "#465258",
    bg3 = "#505a60",
    bg4 = "#576268",
    bg5 = "#5f6d67",
    bg_visual = "#5d4251",
    bg_red = "#59454b",
    bg_green = "#48584d",
    bg_blue = "#3d5665",
    bg_yellow = "#55544a",
  },
  light = {
    bg0 = "#f8f0dc",
    bg1 = "#efead4",
    bg2 = "#e9e5cf",
    bg3 = "#e1ddc9",
    bg4 = "#dcd8c4",
    bg5 = "#b9c0ab",
    bg_visual = "#e6e9c4",
    bg_red = "#f9e0d4",
    bg_green = "#edeece",
    bg_blue = "#e7ede5",
    bg_yellow = "#f6e9c9",
  },
}

local base_palette = {
  light = {
    fg = "#5c6a72",
    red = "#f85552",
    orange = "#f57d26",
    yellow = "#dfa000",
    green = "#8da101",
    aqua = "#35a77c",
    blue = "#3a94c5",
    purple = "#df69ba",
    grey0 = "#a6b0a0",
    grey1 = "#939f91",
    grey2 = "#829181",
    statusline1 = "#93b259",
    statusline2 = "#708089",
    statusline3 = "#e66868",
    none = "NONE",
  },
  dark = {
    fg = "#d3c6aa",
    red = "#e67e80",
    orange = "#e69875",
    yellow = "#dbbc7f",
    green = "#a7c080",
    aqua = "#83c092",
    blue = "#7fbbb3",
    purple = "#d699b6",
    grey0 = "#7a8478",
    grey1 = "#859289",
    grey2 = "#9da9a0",
    statusline1 = "#a7c080",
    statusline2 = "#d3c6aa",
    statusline3 = "#e67e80",
    none = "NONE",
  }
}

M.generate_palette = function (options, theme)
  local background = options.background or "medium"
  local base = base_palette[theme]
  local background_palette

  if background == "light" then
    background_palette = light_background[theme]
  elseif background == "hard" then
    background_palette = hard_background[theme]
  else
    background_palette = medium_background[theme]
  end

  return vim.tbl_extend("force", base, background_palette)
end

return M
