---@class Everforest
---@field config Everforest.Config
---@field setup fun(opts: Everforest.SetupOptions?)
---@field load fun()

---@class Everforest.Config
---@field background "soft" | "medium" | "hard"
---@field transparent_background_level 0 | 1 | 2
---@field italics boolean
---@field disable_italic_comments boolean
---@field sign_column_background "none" | "grey"
---@field ui_contrast "low" | "high"
---@field dim_inactive_windows boolean
---@field diagnostic_text_highlight boolean
---@field diagnostic_virtual_text "coloured" | "grey"
---@field diagnostic_line_highlight boolean
---@field spell_foreground boolean
---@field show_eob boolean
---@field float_style "bright" | "dim" | "none"
---@field inlay_hints_background "none" | "dimmed"
---@field on_highlights fun(highlight_groups: Everforest.Highlights, palette: Everforest.Palette)
---@field colours_override fun(palette: Everforest.Palette)

---@class Everforest.SetupOptions
---@field background? "soft" | "medium" | "hard"
---@field transparent_background_level? 0 | 1 | 2
---@field italics? boolean
---@field disable_italic_comments? boolean
---@field sign_column_background? "none" | "grey"
---@field ui_contrast? "low" | "high"
---@field dim_inactive_windows? boolean
---@field diagnostic_text_highlight? boolean
---@field diagnostic_virtual_text? "coloured" | "grey"
---@field diagnostic_line_highlight? boolean
---@field spell_foreground? boolean
---@field show_eob? boolean
---@field float_style? "bright" | "dim" | "none"
---@field inlay_hints_background? "none" | "dimmed"
---@field on_highlights? fun(highlight_groups: Everforest.Highlights, palette: Everforest.Palette)
---@field colours_override? fun(palette: Everforest.Palette)

---@class Everforest.PaletteBackground
---@field bg_dim string
---@field bg0 string
---@field bg1 string
---@field bg2 string
---@field bg3 string
---@field bg4 string
---@field bg5 string
---@field bg_visual string
---@field bg_red string
---@field bg_green string
---@field bg_blue string
---@field bg_yellow string
---@field bg_purple string

---@class Everforest.PaletteBase
---@field fg string
---@field red string
---@field orange string
---@field yellow string
---@field green string
---@field aqua string
---@field blue string
---@field purple string
---@field grey0 string
---@field grey1 string
---@field grey2 string
---@field statusline1 string
---@field statusline2 string
---@field statusline3 string
---@field none string

---@class Everforest.Palette: Everforest.PaletteBase,Everforest.PaletteBackground

---@alias Everforest.Backgrounds "light" | "dark"
---@alias Everforest.PaletteBackgrounds table<Everforest.Backgrounds, Everforest.PaletteBackground>

---@alias Everforest.HighlightArgs "bold" | "underline" | "undercurl" | "underdouble" | "underdotted" | "underdashed" | "strikethrough" | "reverse" | "inverse" | "italic" | "standout" | "altfont" | "nocombine" | "NONE"

---@class Everforest.Highlight
---@field fg string?
---@field bg string?
---@field style Everforest.HighlightArgs[]?
---@field link string?

---@alias Everforest.Highlights table<string, Everforest.Highlight>

---@class Everforest.Util
---@field generate_highlight fun(group: string, hl: Everforest.Highlight)
---@field generate_highlights fun(syntax_entries: Everforest.Highlights)
---@field load fun(generated_syntax: Everforest.Highlights)

---@class Everforest.Colours
---@field generate_palette fun(options: Everforest.Config, theme: "dark" | "light"): Everforest.Palette

---@class Everforest.Highlighter
---@field generate_syntax fun(palette: Everforest.Palette, options: Everforest.Config): Everforest.Highlights

---@class Everforest.ColourUtility
---@field blend fun(foreground: string, alpha: string|number, background: string): string
---@field blend_bg fun(hex: string, amount: string|number, bg: string?): string
---@field darken fun(hex: string, amount: string|number, bg: string?): string
---@field blend_fg fun(hex: string, amount: string|number, bg: string?): string
---@field lighten fun(hex: string, amount: string|number, bg: string?): string
