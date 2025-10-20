---Forest Flower Day variant
---Loads the colorscheme with day flavour

local forestflower = require("forestflower")

-- Override flavour to day while preserving other config settings
forestflower.config.flavour = "day"

-- Load the colorscheme
forestflower.load()

