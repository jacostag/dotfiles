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

local act = wezterm.action

config.keys = {
	{ key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "[", mods = "CMD", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "CMD", action = act.ActivateTabRelative(1) },
	{ key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
	{ key = "y", mods = "CMD", action = wezterm.action.ActivateLastTab },
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
}

return config
