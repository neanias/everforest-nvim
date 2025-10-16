---Highlight system for Forest Flower colorscheme
---Provides utilities for creating highlight groups efficiently

---@class HighlightStyles
---@field bold string
---@field italic string
---@field reverse string
---@field undercurl string
---@field underline string
---@field standout string
---@field strikethrough string
---@field nocombine string

---@alias Highlight vim.api.keyset.highlight
---@alias Highlights table<string,Highlight>

local M = {}

---Available highlight styles
M.styles = {
  bold = "bold",
  italic = "italic",
  reverse = "reverse",
  undercurl = "undercurl",
  underline = "underline",
  standout = "standout",
  strikethrough = "strikethrough",
  nocombine = "nocombine",
}

---Create a highlight entry
---@param fg string|nil Foreground color
---@param bg string|nil Background color
---@param stylings string[]|nil Array of style names
---@param sp string|nil Special color (for undercurl)
---@return Highlight
function M.create(fg, bg, stylings, sp)
  local highlight = {}
  
  if fg then highlight.fg = fg end
  if bg then highlight.bg = bg end
  
  if stylings then
    for _, style in ipairs(stylings) do
      if M.styles[style] then
        highlight[M.styles[style]] = true
      end
    end
  end
  
  if sp then highlight.sp = sp end
  
  return highlight
end

---Create a link to another highlight group
---@param target string Target highlight group name
---@return Highlight
function M.link(target)
  return { link = target }
end

---Create base color definitions
---@param palette ColorPalette
---@param styles table
---@return Highlights
function M.create_base_colors(palette, styles)
  return {
    -- Base colors
    Red = M.create(palette.error, palette.none),
    Green = M.create(palette.success, palette.none),
    Blue = M.create(palette.info, palette.none),
    Yellow = M.create(palette.warning, palette.none),
    Orange = M.create(palette.warning, palette.none),
    Purple = M.create(palette.tertiary, palette.none),
    Aqua = M.create(palette.secondary, palette.none),
    Grey = M.create(palette.success, palette.none),
    
    -- Color variants
    RedBold = M.create(palette.error, palette.none, { styles.bold }),
    GreenBold = M.create(palette.success, palette.none, { styles.bold }),
    BlueBold = M.create(palette.info, palette.none, { styles.bold }),
    YellowBold = M.create(palette.warning, palette.none, { styles.bold }),
    OrangeBold = M.create(palette.warning, palette.none, { styles.bold }),
    PurpleBold = M.create(palette.tertiary, palette.none, { styles.bold }),
    AquaBold = M.create(palette.secondary, palette.none, { styles.bold }),
    
    RedItalic = M.create(palette.error, palette.none, { styles.italic }),
    GreenItalic = M.create(palette.success, palette.none, { styles.italic }),
    BlueItalic = M.create(palette.info, palette.none, { styles.italic }),
    YellowItalic = M.create(palette.warning, palette.none, { styles.italic }),
    OrangeItalic = M.create(palette.warning, palette.none, { styles.italic }),
    PurpleItalic = M.create(palette.tertiary, palette.none, { styles.italic }),
    AquaItalic = M.create(palette.secondary, palette.none, { styles.italic }),
  }
end

return M

