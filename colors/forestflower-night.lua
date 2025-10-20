---Forest Flower Night variant
---Loads the colorscheme with night flavour

local forestflower = require("forestflower")

-- Override flavour to night while preserving other config settings
forestflower.config.flavour = "night"

-- Load the colorscheme
forestflower.load()

