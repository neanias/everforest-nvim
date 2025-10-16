---@class MaterialTokens
---@field primary string
---@field primary_container string
---@field secondary string
---@field secondary_container string
---@field tertiary string
---@field tertiary_container string
---@field error string
---@field error_container string
---@field success string
---@field success_container string
---@field warning string
---@field warning_container string
---@field info string
---@field info_container string
---@field hint string
---@field hint_container string
---@field background string
---@field on_background string
---@field surface string
---@field on_surface string
---@field surface_variant string
---@field on_surface_variant string
---@field outline string
---@field outline_variant string
---@field none string

local palettes = {
  night = {
    primary = "#a7c080",
    primary_container = "#2d4d3a",
    secondary = "#7fbbb3",
    secondary_container = "#2d4d4a",
    tertiary = "#d699b6",
    tertiary_container = "#4d3d4a",
    error = "#f85552",
    error_container = "#4d2d3a",
    success = "#a7c080",
    success_container = "#2d4d3a",
    warning = "#f6c177",
    warning_container = "#4d4a2d",
    info = "#7fbbb3",
    info_container = "#2d4d4a",
    hint = "#9e9fb3",
    hint_container = "#3d4a4d",
    background = "#101010",
    on_background = "#a7c080",
    surface = "#1e2326",
    on_surface = "#a7c080",
    surface_variant = "#2d3338",
    on_surface_variant = "#596267",
    outline = "#353b40",
    outline_variant = "#3d4247",
    none = "NONE",
  },
  day = {
    primary = "#8da101",
    primary_container = "#e8f5d5",
    secondary = "#3a94c5",
    secondary_container = "#d5e8f5",
    tertiary = "#df69ba",
    tertiary_container = "#f5d5e8",
    error = "#f85552",
    error_container = "#f5d5d5",
    success = "#8da101",
    success_container = "#e8f5d5",
    warning = "#dfa000",
    warning_container = "#f5f0d5",
    info = "#3a94c5",
    info_container = "#d5e8f5",
    hint = "#6d8fb3",
    hint_container = "#e8edf5",
    background = "#fffbef",
    on_background = "#5c6a72",
    surface = "#f8f5e4",
    on_surface = "#5c6a72",
    surface_variant = "#edeada",
    on_surface_variant = "#9eac91",
    outline = "#c3cbb5",
    outline_variant = "#b1bca3",
    none = "NONE",
  },
}

local syntax = {
  keyword = "#c4a7e7",
  operator = "#89b4fa",
  ["function"] = "#c4a7e7",
  method = "#c4a7e7",
  type = "#74c7ec",
  interface = "#74c7ec",
  enum = "#74c7ec",
  constant = "#9d7cd8",
  number = "#ea9a97",
  boolean = "#ea9a97",
  string = "#a7c080",
  variable = "#e0def4",
  parameter = "#94e2d5",
  property = "#89dceb",
  field = "#e0def4",
  namespace = "#c4a7e7",
  comment = "#6e6a86",
  punctuation = "#c4a7e7",
  macro = "#c4a7e7",
  special = "#9ccfd8",
  todo = "#f6c177",
  hint = "#9ccfd8",
  info = "#9ccfd8",
  warn = "#f6c177",
  error = "#eb6f92",
  jsx_component = "#dd7878",
  jsx_prop = "#cba6f7",
}

local M = {}
M.palettes = palettes
M.syntax = syntax

return M
