local wez = require("wezterm")
local act = wez.action
local mux = wez.mux
local workspace_switcher = wez.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local resurrect = wez.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local M = {}

M.general = {
	{ key = "t", mods = "CTRL", action = act.ActivateKeyTable({ name = "personal", one_shot = true }) },

	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") }, -- copy with cmd/super/win + c
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") }, -- paste with cmd/super/win +v
	{ key = "q", mods = "CMD", action = act.QuitApplication },
	{ key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") }, -- ctrl + shift + c for copy
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") }, -- ctrl + shift + v for paste
	{ key = "P", mods = "CTRL", action = act.ActivateCommandPalette },
	{ key = "W", mods = "CTRL", action = wez.action.CloseCurrentTab({ confirm = true }) },
	{ key = "q", mods = "CMD", action = act.QuitApplication },
	-- CTRL-SHIFT-l activates the debug overlay
	-- { key = "D", mods = "CTRL", action = wez.action.ShowDebugOverlay },
}

M.personal = {
	{ key = "t", action = act.SpawnTab("CurrentPaneDomain") }, -- new tab, same domain and cwd
	{ key = "t", mods = "CTRL", action = act.ActivateLastTab }, -- last tab
	{ key = "x", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", action = act.TogglePaneZoomState },
	{ key = "n", action = act.QuickSelect },
	{ key = "c", action = act.ActivateCopyMode },
	{ key = "w", action = workspace_switcher.switch_workspace() },
	{ key = "l", action = workspace_switcher.switch_to_prev_workspace() }, -- last workspace
	{ key = "s", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "/", action = act.ShowLauncherArgs({ flags = "FUZZY|TABS" }) }, -- fzf navigate tabs
	{ key = "p", mods = "CTRL", action = act.PaneSelect({ alphabet = "neioarst", mode = "Activate" }) }, -- move between panes
	-- { key = "j", action = act.Search("CurrentSelectionOrEmptyString") },

	{ --rename tab, only visible for inactive tabs (tabline)
		key = "r",
		action = act.PromptInputLine({
			description = wez.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Blue" } },
				{ Text = "Rename tab to:" },
			}),
			action = wez.action_callback(function(window, pane, line)
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
		action = wez.action_callback(function(win, pane)
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
		action = wez.action_callback(function(win, pane)
			resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
			resurrect.window_state.save_window_action()
			resurrect.tab_state.save_tab_action()
			-- win:toast_notification("Wezterm", "Save Resurrect", nil, 4000) -- notification as well
		end),
	},

	{ -- create a new workspace with name
		key = "W",
		action = act.PromptInputLine({
			description = wez.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Blue" } },
				{ Text = "New workspace name:" },
			}),
			action = wez.action_callback(function(window, pane, line)
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
		mods = "SHIFT",
		action = act.PromptInputLine({
			description = wez.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Blue" } },
				{ Text = "New name for current workspace:" },
			}),
			action = wez.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},

	{ -- call external command exmample
		key = "b",
		action = act.SplitHorizontal({
			args = { "wezterm_tab_switcher.sh" },
		}),
	},
	{
		key = "T",
		action = act.SplitHorizontal({
			args = { "taskwarrior-tui" },
		}),
	},
}

-- MOUSE --
M.mouse_bindings = {
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

return M
