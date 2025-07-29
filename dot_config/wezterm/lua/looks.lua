local wez = require("wezterm")
local plugin_config = require("lua.plugins")
local tabline = wez.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local workspace = wez.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local M = {}

M.apply_to_config = function(c)
	c.color_scheme = "Catppuccin Mocha"
	local scheme = wez.color.get_builtin_schemes()["Catppuccin Mocha"]
	c.colors = {
		background = "#1e1e2e",
		cursor_border = scheme.ansi[2],
		tab_bar = {
			background = plugin_config.tab_background,
			active_tab = {
				bg_color = scheme.background,
				fg_color = scheme.ansi[3],
			},
			inactive_tab = {
				bg_color = plugin_config.tab_background,
				fg_color = scheme.ansi[1],
			},
			inactive_tab_hover = {
				bg_color = plugin_config.tab_background,
				fg_color = scheme.ansi[1],
			},
		},
	}
	c.window_padding = {
		left = 0,
		right = 0,
		top = 5,
		bottom = 0,
	}
	c.window_background_image_hsb = {
		brightness = 1,
		saturation = 1,
		hue = 1,
	}
	c.window_decorations = "RESIZE"
	c.tab_max_width = 50
	c.use_fancy_tab_bar = false

	c.font = wez.font("Fira Code Nerdfont")
	c.font_size = 16.0
	c.scrollback_lines = 5000
	c.hide_tab_bar_if_only_one_tab = true
	c.disable_default_key_bindings = true
	c.adjust_window_size_when_changing_font_size = false
	c.initial_rows = 52
	c.initial_cols = 200
	c.window_close_confirmation = "NeverPrompt"
	c.warn_about_missing_glyphs = false
	c.enable_wayland = true
	c.window_background_opacity = 0.9
	c.text_background_opacity = 0.9
	c.quick_select_alphabet = "colemak"
	c.detect_password_input = true
	c.enable_kitty_graphics = true
	c.max_fps = 120
	c.hyperlink_rules = wez.default_hyperlink_rules()
	c.front_end = "WebGpu"
	c.webgpu_power_preference = "HighPerformance"
	c.xcursor_theme = "Adwaita"
	c.switch_to_last_active_tab_when_closing_tab = true
	c.inactive_pane_hsb = {
		brightness = 0.3,
	}
	workspace.get_choices = function(opts)
		return workspace.choices.get_workspace_elements({})
	end
	tabline.setup(plugin_config.tabline)
end

return M
