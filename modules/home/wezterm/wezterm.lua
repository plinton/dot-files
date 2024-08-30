-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'

--config.tab_bar_at_bottom = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"


-- and finally, return the configuration to wezterm
return config
