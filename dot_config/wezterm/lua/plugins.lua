local wez = require("wezterm")
local scheme = wez.color.get_builtin_schemes()["Catppuccin Mocha"]
local smart_workspace = wez.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local quick_domains = wez.plugin.require("https://github.com/DavidRR-F/quick_domains.wezterm")

local M = {}

M.tab_background = "#11111b"
M.catpuccin_purple = "#ca9ee6"

local mode_icons = {
	NO = "", -- Normal Mode
	CO = "", -- Visual Mode
	SE = "", -- Search Mode
	WI = "󱀦", -- Window Mode
	SW = "", -- Switch Mode
	DM = "", -- Domain Mode
	RE = "", -- Resurrect
}

M.tabline = {
	options = {
		icons_enabled = true,
		theme = "Catppuccin Mocha",
		theme_overrides = {
			normal_mode = {
				a = { fg = scheme.ansi[5], bg = M.tab_background },
				b = { fg = scheme.ansi[5], bg = M.tab_background },
			},
			copy_mode = {
				a = { fg = scheme.ansi[4], bg = M.tab_background },
				b = { fg = scheme.ansi[4], bg = M.tab_background },
			},
			search_mode = {
				a = { fg = scheme.ansi[3], bg = M.tab_background },
				b = { fg = scheme.ansi[3], bg = M.tab_background },
			},
			-- Defining colors for a new key table
			window_mode = {
				a = { fg = M.catpuccin_purple, bg = M.tab_background },
				b = { fg = M.catpuccin_purple, bg = M.tab_background },
			},
			tab = {
				active = {
					bg = scheme.background,
					fg = "#89b4fa",
				},
				inactive = {
					bg = M.tab_background,
					fg = M.catpuccin_purple,
				},
				inactive_hover = {
					bg = scheme.background,
					-- bg = M.tab_background,
					fg = M.catpuccin_purple,
				},
			},
		},
		section_separators = "",
		component_separators = "",
		tab_separators = {
			left = "",
			right = "",
		},
	},
	sections = {
		tabline_a = {
			{
				"mode",
				padding = { left = 1, right = 0 },
				fmt = function(str)
					return mode_icons[str:sub(1, 2)]
				end,
			},
		},
		tabline_b = {
			{
				"workspace",
				icon = "",
				padding = { left = 0, right = 1 },
				fmt = function(workspace, window)
					if window:active_key_table() == "personal" then -- my key table is called personal, I no longer use leader key
						return workspace .. " " .. "🟡" -- The icon will appear on "command" mode, "waiting" for the next key press
					end
					return workspace
				end,
			},
		},
		tabline_c = { "domain" },
		tab_active = {
			"index",
			"parent",
			-- { "cwd", padding = { left = 0, right = 1 } },
			"process",
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "tab", padding = { left = 0, right = 1 } }, "process", "output" },
		tabline_x = {},
		tabline_y = {},
		tabline_z = {},
	},
	extensions = {
		{
			"quick_domains",
			events = {
				show = "quick_domain.fuzzy_selector.opened",
				hide = {
					"quick_domain.fuzzy_selector.canceled",
					"quick_domain.fuzzy_selector.selected",
					"resurrect.fuzzy_load.start",
					"smart_workspace_switcher.workspace_switcher.start",
				},
			},
			sections = {
				tabline_a = {
					{
						"mode",
						padding = { left = 1, right = 0 },
						fmt = function(str)
							return mode_icons["DM"]
						end,
					},
				},
				tabline_b = {
					{
						"workspace",
						icon = "",
						padding = { left = 0, right = 1 },
					},
				},
			},
			colors = {
				a = { fg = scheme.ansi[6], bg = M.tab_background },
				b = { fg = scheme.ansi[6], bg = M.tab_background },
			},
		},
		{
			"smart_workspace_switcher",
			events = {
				show = "smart_workspace_switcher.workspace_switcher.start",
				hide = {
					"smart_workspace_switcher.workspace_switcher.canceled",
					"smart_workspace_switcher.workspace_switcher.chosen",
					"smart_workspace_switcher.workspace_switcher.created",
					"resurrect.fuzzy_load.start",
					"quick_domain.fuzzy_selector.opened",
				},
			},
			sections = {
				tabline_a = {
					{
						"mode",
						padding = { left = 1, right = 0 },
						fmt = function(str)
							return mode_icons["SW"]
						end,
					},
				},
				tabline_b = {
					{
						"workspace",
						icon = "",
						padding = { left = 0, right = 1 },
					},
				},
			},
			colors = {
				a = { fg = scheme.ansi[2], bg = M.tab_background },
				b = { fg = scheme.ansi[2], bg = M.tab_background },
			},
		},
		{
			"resurrect",
			events = {
				show = "resurrect.fuzzy_load.start",
				hide = {
					"resurrect.fuzzy_load.finished",
					"quick_domain.fuzzy_selector.opened",
					"smart_workspace_switcher.workspace_switcher.start",
				},
			},
			sections = {
				tabline_a = {
					{
						"mode",
						padding = { left = 1, right = 0 },
						fmt = function(str)
							return mode_icons["RE"]
						end,
					},
				},
				tabline_b = {
					{
						"workspace",
						icon = "",
						padding = { left = 0, right = 1 },
					},
				},
			},
			colors = {
				a = { fg = scheme.ansi[2], bg = M.tab_background },
				b = { fg = scheme.ansi[2], bg = M.tab_background },
			},
		},
	},
}

M.quick_domains = {
	keys = {
		attach = {
			mods = "CTRL",
			key = "d",
			tbl = "personal",
		},
		vsplit = {
			mods = "CTRL",
			key = "v",
			tbl = "personal",
		},
		hsplit = {
			mods = "CTRL",
			key = "h",
			tbl = "personal",
		},
	},
	auto = {
		ssh_ignore = false,
		exec_ignore = {
			ssh = false,
			docker = true,
			kubernetes = true,
		},
	},
}

return M
