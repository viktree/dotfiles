-- Pull in the wezterm API
local wezterm = require "wezterm"


-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'Catppuccin Mocha'
config.color_scheme = "OneHalfDark"

local rosepine_theme = require "lua/rose-pine"
-- config.colors = rosepine_theme.colors()
-- config.window_frame = rosepine_theme.window_frame()

-- config.font = wezterm.font 'Iosevka Nerd Font'

config.font =
    wezterm.font_with_fallback {
    "IosevkaCustom Nerd Font Mono",
    "Iosevka Nerd Font Mono",
    "Monaspace Neon"
}

config.font_size = 14

-- config.font_size = 20

-- config.window_background_opacity = 0.8
-- config.text_background_opacity = 0.7
-- config.macos_window_background_blur = 20

config.enable_tab_bar = false

config.audible_bell = "Disabled"

-- and finally, return the configuration to wezterm
return config
