local wez = require("wezterm")
local mux = wez.mux
local looks = require("lua.looks")
local plugins = require("lua.plugins")
local keys = require("lua.keys")
local smart_workspace = wez.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local quick_domains = wez.plugin.require("https://github.com/DavidRR-F/quick_domains.wezterm")

-- config

local c = {}
if wez.config_builder then
	c = wez.config_builder()
end
c.default_prog = { "fish" }
c.default_workspace = "home"
c.disable_default_key_bindings = true
c.enable_wayland = true
c.keys = keys.general
c.key_tables = { personal = keys.personal }
c.default_domain = "Unix"
c.unix_domains = {
	{
		name = "Unix",
	},
}

wez.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = {}
	if cmd then
		args = cmd.args
	end
	-- workspaces
	local tab, build_pane, window = mux.spawn_window({
		workspace = "home",
		cwd = "/home/gosz/",
		domain = { DomainName = "Unix" },
		cmd = "eza --icons=always --color=always -snewest",
	})
	local tab, pane, window = mux.spawn_window({
		workspace = "work",
		cwd = "/home/gosz/work/",
		domain = { DomainName = "Unix" },
		cmd = "eza --icons=always --color=always -snewest",
	})
	-- We want to startup in the home workspace
	mux.set_active_workspace("home")
end)

looks.apply_to_config(c)

-- EVENTS --
-- Red Alert for password inputs --
wez.on("update-status", function(window, pane)
	local meta = pane:get_metadata() or {}
	local overrides = window:get_config_overrides() or {}
	if meta.password_input then
		-- window:toast_notification("wezterm", "Password input was requested", nil, 50) -- notification as well
		overrides.color_scheme = "Red Alert"
	else
		overrides.color_scheme = nil
	end
	window:set_config_overrides(overrides)
end)

-- bell alert
wez.on("bell", function(window, pane)
	wez.log_info("the bell was rung in pane " .. pane:pane_id() .. "!")
	window:toast_notification("Wezterm", "Bell on: " .. pane:get_domain_name() .. pane:get_title(), nil, 50)
end)

-- plugins

quick_domains.formatter = function(icon, name, label)
	return wez.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { Color = "#89b4fa" } },
		{ Background = { Color = "#1e1e2e" } },
		{ Text = icon .. " " .. name .. ": " .. label },
	})
end

quick_domains.apply_to_config(c, plugins.quick_domains)
smart_workspace.apply_to_config(c)

return c
