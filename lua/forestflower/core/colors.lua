---Core color system for Forest Flower colorscheme
---Defines the base color palette and semantic color tokens
---
---BRAND IDENTITY:
---  Nature-inspired colorscheme for mindful programming
---  For developers who code in long sessions and value eye health
---
---CORE VALUES:
---  • Mindful Focus: Conscious, relaxed, sustained attention
---  • Health-First: Warm tones reduce eye strain (8+ hour sessions)
---  • Nature-Inspired: Colors from flowers, plants, twilight skies
---  • Timeless Simplicity: Minimum noise, maximum clarity
---
---COLOR ARCHITECTURE:
---  UI Palette = Environment (sky, earth, natural light)
---  Syntax Tokens = Flora (flower-inspired, vibrant yet organic)
---
---DESIGN CONSTRAINTS:
---  ✅ Natural colors only (no neon, electric, corporate branding)
---  ✅ Warm golden undertones (twilight-range temperature)
---  ✅ Sustainable contrast (health over maximum pop)
---  ✅ Timeless over trendy (resist UI fads)

---@class ColorPalette
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

---@class SyntaxTokens
---@field keyword string
---@field operator string
---@field function string
---@field method string
---@field type string
---@field interface string
---@field enum string
---@field constant string
---@field number string
---@field boolean string
---@field string string
---@field variable string
---@field parameter string
---@field property string
---@field field string
---@field namespace string
---@field comment string
---@field punctuation string
---@field macro string
---@field special string
---@field todo string
---@field hint string
---@field info string
---@field warn string
---@field error string
---@field jsx_component string

local M = {}

---Night palette - Twilight tones optimized for long coding sessions
M.palettes = {
  night = {
    -- Primary: Forest greenery (living, growing)
    primary = "#b4d494",
    primary_container = "#2d4d3a",
    
    -- Secondary: Sky at twilight (clear, spacious)
    secondary = "#7fbbb3",
    secondary_container = "#2d4d4a",
    
    -- Tertiary: Sunset/flower tones (warm, delicate)
    tertiary = "#d699b6",
    tertiary_container = "#4d3d4a",
    
    -- Semantic colors
    error = "#f85552",
    error_container = "#4d2d3a",
    success = "#b4d494",
    success_container = "#2d4d3a",
    warning = "#f6c177",
    warning_container = "#4d4a2d",
    info = "#7fbbb3",
    info_container = "#2d4d4a",
    hint = "#5a5f6f",
    hint_container = "#1a1e23",
    
    -- Surfaces: Forest floor to canopy layering
    background = "#101010",        -- Deep earth with warm undertone
    on_background = "#e6e1cf",     -- Warm natural light
    surface = "#1e2326",           -- Forest floor
    on_surface = "#d3c6aa",        -- Filtered sunlight
    surface_variant = "#252a30",   -- Elevated surface (dappled light)
    on_surface_variant = "#8a8a7a", -- Muted secondary text
    
    -- Borders & outlines
    outline = "#3a3f47",
    outline_variant = "#3d4247",
    
    none = "NONE",
  },
  day = {
    -- Primary: Sunlit greenery (vibrant, alive)
    primary = "#8da101",
    primary_container = "#e8f5d5",
    
    -- Secondary: Warm sky blue (not corporate blue)
    secondary = "#5a9bb3",
    secondary_container = "#d5e8f5",
    
    -- Tertiary: Flower pink (warm, natural)
    tertiary = "#df69ba",
    tertiary_container = "#f5d5e8",
    
    -- Semantic colors
    error = "#f85552",
    error_container = "#f5d5d5",
    success = "#8da101",
    success_container = "#e8f5d5",
    warning = "#dfa000",
    warning_container = "#f5f0d5",
    info = "#5a9bb3",
    info_container = "#d5e8f5",
    hint = "#8a9199",
    hint_container = "#f8f5e4",
    
    -- Surfaces: Sunlit warm tones
    background = "#fffbef",
    on_background = "#2d3338",
    surface = "#f8f5e4",
    on_surface = "#2d3338",
    surface_variant = "#edeada",
    on_surface_variant = "#5a5a5a",
    
    -- Borders & outlines
    outline = "#8a9199",
    outline_variant = "#b1bca3",
    
    none = "NONE",
  },
}

---Syntax highlighting - Flora-inspired tokens
---Each color represents a natural element for memorability and distinctness
---Warm-shifted palette aligned with twilight/nature identity
M.syntax = {
  keyword = "#c4a7e7",        -- Kurinji purple (distinctive bloom)
  operator = "#8fb4b3",       -- Warm sky blue (twilight sky, not electric)
  ["function"] = "#f6c177",   -- Champak gold (warm, inviting)
  method = "#f6c177",         -- Champak gold
  type = "#89b4a8",           -- Warm sage (between sky and earth)
  interface = "#89b4a8",      -- Warm sage
  enum = "#89b4a8",           -- Warm sage
  constant = "#ea9a97",       -- Hibiscus coral (stands out)
  number = "#ea9a97",         -- Hibiscus coral
  boolean = "#ea9a97",        -- Hibiscus coral
  string = "#a7c080",         -- Forest green (foundational)
  variable = "#e0def4",       -- Jasmine white (soft, natural)
  parameter = "#a8c9a8",      -- Warm mint (fresh, green-leaning)
  property = "#a8c4b8",       -- Warm morning mist (subtle, clear)
  field = "#e0def4",          -- Jasmine white
  namespace = "#b8a89a",      -- Earth clay (grounded, natural)
  comment = "#6e6a86",        -- Twilight gray (present but receded)
  punctuation = "#9ab8b5",    -- Warm rain (connective, soft)
  macro = "#dfa97a",          -- Sunset orange (between gold and coral)
  special = "#9ab8b5",        -- Warm rain
  todo = "#f6c177",           -- Champak gold (attention)
  hint = "#9ab8b5",           -- Warm rain
  info = "#9ab8b5",           -- Warm rain
  warn = "#f6c177",           -- Champak gold
  error = "#eb6f92",          -- Rose red (alert)
  jsx_component = "#dd7878",  -- Coral (React component)
}

return M
