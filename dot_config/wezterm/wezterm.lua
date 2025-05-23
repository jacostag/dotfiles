local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"
config.default_prog = { "/usr/bin/fish" }
config.font = wezterm.font("Fira Code Nerdfont")
config.font_size = 16.0
config.scrollback_lines = 10000
config.hide_tab_bar_if_only_one_tab = true
config.disable_default_key_bindings = true
config.adjust_window_size_when_changing_font_size = false
config.initial_rows = 52
config.initial_cols = 200
config.window_close_confirmation = "NeverPrompt"
config.warn_about_missing_glyphs = false
config.enable_wayland = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.text_background_opacity = 0.9
config.quick_select_alphabet = "colemak"

config.enable_kitty_graphics = true
config.max_fps = 120

local act = wezterm.action

config.keys = {
	-- { key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
	-- { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
	{ key = "[", mods = "CMD", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "CMD", action = act.ActivateTabRelative(1) },
	{ key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
	{ key = "y", mods = "CMD", action = wezterm.action.ActivateLastTab },
	{ key = "u", mods = "CMD", action = wezterm.action.QuickSelect },
	{ key = "i", mods = "CMD", action = wezterm.action.ShowTabNavigator },
}

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("PrimarySelection"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	-- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.Nop,
	},
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "CTRL",
		action = act.IncreaseFontSize,
	},

	-- Scrolling down while holding CTRL decreases the font size
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "CTRL",
		action = act.DecreaseFontSize,
	},
}

-- wezterm.on("user-var-changed", function(window, pane, name, value)
-- 	local overrides = window:get_config_overrides() or {}
-- 	if name == "ZEN_MODE" then
-- 		local incremental = value:find("+")
-- 		local number_value = tonumber(value)
-- 		if incremental ~= nil then
-- 			while number_value > 0 do
-- 				window:perform_action(wezterm.action.IncreaseFontSize, pane)
-- 				number_value = number_value - 1
-- 			end
-- 			overrides.enable_tab_bar = false
-- 		elseif number_value < 0 then
-- 			window:perform_action(wezterm.action.ResetFontSize, pane)
-- 			overrides.font_size = nil
-- 			overrides.enable_tab_bar = true
-- 		else
-- 			overrides.font_size = number_value
-- 			overrides.enable_tab_bar = false
-- 		end
-- 	end
-- 	window:set_config_overrides(overrides)
-- end)

return config
