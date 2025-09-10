---@type Everforest.Util
local util = require("everforest.util")
---@type Everforest.Colours
local colours = require("everforest.colours")
---@type Everforest.Highlighter
local highlights = require("everforest.highlights")

---@class Everforest
local M = {
  ---@type Everforest.Config
  default_config = {
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
    ---dimmed symbols. This is due to the way Vim and Neovim handle
    ---`EndOfBuffer`.
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
    ---The special value `"none"` causes floating windows to be displayed with the
    ---same background as normal windows. Only use this style if Neovim is configured
    ---with a non-empty |"winborder"|, otherwise floating windows will visually blend
    ---into the main buffer. Plugins which create floating windows without border by
    ---default may also need to be configured individually.
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
    on_highlights = function(highlight_groups, palette) end, ---@diagnostic disable-line:unused-local
    ---You can override colours in the palette to use different hex colours.
    ---This function will be called once the base and background colours have
    ---been mixed on the palette.
    colours_override = function(palette) end, ---@diagnostic disable-line:unused-local
  },
}

---@type Everforest.Config
M.config = M.default_config

M.setup = function(opts)
  M.config = vim.tbl_extend("keep", opts or {}, M.default_config)
end

M.load = function()
  local palette = colours.generate_palette(M.config, vim.o.background)
  local generated_syntax = highlights.generate_syntax(palette, M.config)

  util.load(generated_syntax)
end

M.colorscheme = M.load

return M
