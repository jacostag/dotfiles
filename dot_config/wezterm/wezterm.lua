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
-- c.default_domain = "Unix"
-- c.unix_domains = {
-- 	{
-- 		name = "Unix",
-- 	},
-- }

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
		-- domain = { DomainName = "Unix" },
	})
	build_pane:send_text("eza --icons=always --color=always -snewest\n")
	local tab, build_pane, window = mux.spawn_window({
		workspace = "work",
		cwd = "/home/gosz/work/",
		-- domain = { DomainName = "Unix" },
		-- cmd = "eza --icons=always --color=always -snewest",
	})
	build_pane:send_text("nvim\n")
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

-- on window focus change, save the lines as Text
-- local io = require("io")
-- local os = require("os")

-- wez.on("something", function(window, pane)
-- 	wez.log_info("the bell was rung in pane " .. pane:pane_id() .. "!")
-- 	window:toast_notification("Wezterm", "Bell on: " .. pane:get_domain_name() .. pane:get_title(), nil, 50)
-- local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
-- local name = os.tmpname()
-- local f = io.open(name, "w+")
-- f:write(text)
-- f:flush()
-- f:close()
-- window:toast_notification("window-focus-change pane" .. pane:pane_id() .. "window" .. window:window_id() .. "file")
-- end)

local act = wez.action
local name = os.tmpname()
local f = io.open(name, "w+")
wez.on("trigger-vim-with-scrollback", function(window, pane)
	window:toast_notification("Wezterm", "trigger nvim with scrollback")
	-- Retrieve the text from the pane
	local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

	-- Create a temporary file to pass to vim
	f:write(text)
	f:flush()
	f:close()

	-- Open a new window running vim and tell it to open the file
	window:perform_action(
		act.SpawnCommandInNewWindow({
			args = { "nvim", name },
		}),
		pane
	)

	wez.on("window-focus-changed", function(window, pane)
		window:toast_notification("Wezterm", "window-focus-changed")
		wez.log_info("the focus state of ", window:window_id(), " changed to ", window:is_focused())
	end)

	-- Wait "enough" time for vim to read the file before we remove it.
	-- The window creation and process spawn are asynchronous wrt. running
	-- this script and are not awaitable, so we just pick a number.
	--
	-- Note: We don't strictly need to remove this file, but it is nice
	-- to avoid cluttering up the temporary directory.
	wez.sleep_ms(1000)
	os.remove(name)
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
