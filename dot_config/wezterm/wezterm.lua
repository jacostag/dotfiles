local wezterm = require("wezterm")
local config = {}
local mux = wezterm.mux
local act = wezterm.action
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
config.window_background_opacity = 0.9
config.text_background_opacity = 0.9
config.quick_select_alphabet = "colemak"
config.detect_password_input = true
config.enable_kitty_graphics = true
config.max_fps = 120
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.enable_kitty_keyboard = true
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.xcursor_theme = "Adwaita"
config.switch_to_last_active_tab_when_closing_tab = true
config.default_workspace = "home"
config.unix_domains = {
	{
		name = "unix",
	},
}
config.inactive_pane_hsb = {
	brightness = 0.3,
}

-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "t", mods = "CTRL", timeout_milliseconds = 1000 }

wezterm.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = {}
	if cmd then
		args = cmd.args
	end
	-- workspaces
	local tab, build_pane, window = mux.spawn_window({
		workspace = "home",
		cwd = "$HOME",
	})
	local tab, pane, window = mux.spawn_window({
		workspace = "work",
		cwd = "$HOME/work/",
	})
	-- We want to startup in the home workspace
	mux.set_active_workspace("home")
end)

-- PLUGINS --

-- Tabline --
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local process_to_icon = {
	["fish"] = { wezterm.nerdfonts.md_fish, color = { fg = "#faba4a" } },
	["git"] = { wezterm.nerdfonts.dev_git, color = { fg = "#f05133" } },
	["lazygit"] = { wezterm.nerdfonts.dev_git, color = { fg = "#f05133" } },
	["node"] = { wezterm.nerdfonts.md_nodejs, color = { fg = "#417e38" } },
}
tabline.setup({
	options = {
		icons_enabled = true,
		tabs_enabled = true,
		theme = "Catppuccin Mocha",
		theme_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
	},
	sections = {
		tabline_a = { "mode" },
		-- tabline_a = {
		-- 	{
		-- 		"mode",
		-- 		fmt = function(str)
		-- 			return str:sub(1, 3)
		-- 		end,
		-- 	},
		-- },
		tabline_b = { "workspace" },
		tabline_c = { "domain" },
		tab_active = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			{ "process" },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = {
			"index",
			-- "cwd",
			-- "parent",
			-- { "process", process_to_icon = process_to_icon, padding = { left = 0, right = 1 } },
			"tab",
			"output",
		},
		tabline_x = {},
		tabline_y = {},
		tabline_z = {},
	},
	extensions = { "resurrect", "smart_workspace_switcher", "quick_domains" },
})

-- quick_domains -- use ssh config to create a new tab on a new domain for the connection
local domains = wezterm.plugin.require("https://github.com/DavidRR-F/quick_domains.wezterm")
domains.apply_to_config(config, {
	keys = {
		attach = {
			key = "d",
			mods = "LEADER",
			tbl = "",
		},
	},
	auto = {
		ssh_ignore = true,
		exec_ignore = {
			ssh = true,
			docker = true,
			kubernetes = true,
			unix = true,
		},
	},
})

-- resurrect.wezterm --
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.state_manager.periodic_save({
	interval_seconds = 15 * 60,
	save_workspaces = true,
	save_windows = true,
	save_tabs = true,
})

-- workspace_switcher --
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.get_choices = function(opts)
	-- this will ONLY show the workspace elements, NOT the Zoxide results
	return workspace_switcher.choices.get_workspace_elements({})
end

-- KEYS --
config.keys = {
	-- Send "CTRL-T" to the terminal when pressing CTRL-T, CTRL-T
	{
		key = "t",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "t", mods = "CTRL" }),
	},
	-- { key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") }, -- ctrl + shift + c for copy
	-- { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") }, -- ctrl + shift + v for paste
	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") }, -- copy with cmd/super/win + c
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") }, -- paste with cmd/super/win +v
	-- { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) }, -- go to the tab on the left
	-- { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) }, -- go to the tab on the right
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") }, -- new tab, same domain and cwd
	{ key = "q", mods = "CMD", action = act.QuitApplication },
	{ key = "n", mods = "LEADER", action = act.QuickSelect },
	{ key = "t", mods = "LEADER|CTRL", action = act.ActivateLastTab }, -- last tab
	{ key = "w", mods = "LEADER", action = workspace_switcher.switch_workspace() },
	{ key = "l", mods = "LEADER", action = workspace_switcher.switch_to_prev_workspace() }, -- last workspace
	{ key = "P", mods = "CTRL", action = act.ActivateCommandPalette },
	{ key = "W", mods = "CTRL", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ key = "c", mods = "LEADER", action = "ActivateCopyMode" },
	{ key = "s", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "/", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|TABS" }) }, -- fzf navigate tabs
	-- { key = "W", mods = "CTRL", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "p", mods = "LEADER", action = act.PaneSelect({ alphabet = "neioarst", mode = "Activate" }) }, -- move between panes

	{ -- call external command exmample
		key = "b",
		mods = "LEADER",
		action = act.SplitHorizontal({
			args = { "taskwarrior-tui" },
		}),
	},

	{ --rename tab, only visible for inactive tabs (tabline)
		key = "r",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Blue" } },
				{ Text = "Rename tab to:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	{ -- restore resurrect
		key = "R",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.state_manager.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
					-- win:toast_notification("Wezterm", "Restore Workspace Resurrect", nil, 4000) -- notification as well
				elseif type == "window" then
					local state = resurrect.state_manager.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
					-- win:toast_notification("Wezterm", "Restore Window Resurrect", nil, 4000) -- notification as well
				elseif type == "tab" then
					local state = resurrect.state_manager.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
					-- win:toast_notification("Wezterm", "Restore Tab Resurrect", nil, 4000) -- notification as well
				end
			end)
		end),
	},

	{ -- save resurrect
		key = "S",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
			resurrect.window_state.save_window_action()
			resurrect.tab_state.save_tab_action()
			-- win:toast_notification("Wezterm", "Save Resurrect", nil, 4000) -- notification as well
		end),
	},

	{ -- create a new workspace with name
		key = "W",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Blue" } },
				{ Text = "New workspace:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},

	{ -- rename current workspace
		key = "$",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Blue" } },
				{ Text = "New name for current workspace:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
}

-- MOUSE --
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelectionOrOpenLinkAtMouseCursor("PrimarySelection"),
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
	-- Scrolling up/down while holding CTRL increases/decreases the font size
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "CTRL",
		action = act.IncreaseFontSize,
	},
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "CTRL",
		action = act.DecreaseFontSize,
	},
}

-- EVENTS --
-- Red Alert for password inputs --
wezterm.on("update-status", function(window, pane)
	local meta = pane:get_metadata() or {}
	local overrides = window:get_config_overrides() or {}
	if meta.password_input then
		overrides.color_scheme = "Red Alert"
		window:toast_notification("wezterm", "Password input was requested", nil, 4000) -- notification as well
	else
		overrides.color_scheme = nil
	end
	window:set_config_overrides(overrides)
end)

-- bell alert
wezterm.on("bell", function(window, pane)
	wezterm.log_info("the bell was rung in pane " .. pane:pane_id() .. "!")
	window:toast_notification("Wezterm", "Bell on: " .. pane:get_domain_name() .. pane:get_title(), nil, 4000)
end)

-- show if error for resurrect
wezterm.on("resurrect.error", function(err)
	wezterm.log_error("ERROR!")
	wezterm.gui.gui_windows()[1]:toast_notification("resurrect", err, nil, 3000)
end)

-- whenever I create a new workspace, restore content
wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, _, label_path)
	local workspace_state = resurrect.workspace_state
	-- window:toast_notification("Wezterm", "Restore Resurrection NWS", nil, 4000)
	-- loads the state whenever I create a new workspace
	workspace_state.restore_workspace(resurrect.state_manager.load_state(label_path, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		resize_window = false,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

-- Saves the state whenever I select a workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	local workspace_state = resurrect.workspace_state
	-- window:toast_notification("Wezterm", "Save Resurrection SWS", nil, 4000)
	resurrect.state_manager.save_state(workspace_state.get_workspace_state())
	resurrect.state_manager.write_current_state(label, "workspace")
end)

-- local workspace_config = {
-- 	["~/.config/wezterm"] = {
-- 		"nvim",
-- 	},
-- 	["~/.config/nvim"] = {
-- 		"nvim",
-- 	},
-- 	["~/Downloads"] = {
-- 		"yazi",
-- 	},
-- }

-- -- loop over the key/value pairs in the workspace_config above
-- for path, tabs in pairs(workspace_config) do
-- 	-- if the label_path from zoxide / workspace switcher matches a configured path
-- 	if string.match(label_path, path) then
-- 		-- get the initial pane created
-- 		local initial_pane = window:active_pane()
-- 		-- loop over the tabs to get each command to run
-- 		for index, command in ipairs(tabs) do
-- 			-- add a trailing newline if the command doesn't have one
-- 			if #command > 0 and not string.match(command, "\n", -1) then
-- 				command = command .. "\n"
-- 			end
-- 			-- if this is the first configured command, run in the initial pane
-- 			if index == 1 then
-- 				initial_pane:send_text(command)
-- 			else
-- 				-- else, spawn a new tab and run the command in the pane in that tab
-- 				local _, pane = window:spawn_tab({})
-- 				pane:send_text(command)
-- 			end
-- 		end
-- 		-- then finally, focus on the first tab and pane
-- 		-- and break out of the loop
-- 		-- (i.e. use the first matching configured path)
-- 		initial_pane:activate()
-- 		break
-- 	end
-- end

-- whenever I select an active workspace
-- wezterm.on("user-var-changed", function(window, pane, name, value)
-- 	if name == "switch-workspace" then
-- 		local cmd_context = wezterm.json_parse(value)
-- 		window:perform_action(
-- 			act.SwitchToWorkspace({
-- 				name = cmd_context.workspace,
-- 				spawn = {
-- 					cwd = cmd_context.cwd,
-- 				},
-- 			}),
-- 			pane
-- 		)
-- 	end
-- end)

return config
