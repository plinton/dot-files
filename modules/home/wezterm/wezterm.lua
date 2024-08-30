-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- Disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.send_composed_key_when_left_alt_is_pressed = true

config.front_end = "WebGpu"

-- and finally, return the configuration to wezterm
return config
