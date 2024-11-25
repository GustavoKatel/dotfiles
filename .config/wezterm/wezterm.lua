local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

---@diagnostic disable-next-line: undefined-global
NVIM_SPECIAL_LEADER = utf8.char(0xff)

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(string.format("%s [%s]", window:active_workspace(), pane:get_domain_name()))
end)

wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	-- Find the last occurrence of the path separator
	local last_separator = s:match(".*[/\\](.*)")
	-- If no separator is found, return the original path
	if not last_separator then
		return s
	end
	return last_separator
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	local pane = tab_info.active_pane
	local title = string.format(" %s: %s ", tab_info.tab_index + 1, pane.title)

	return title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)
	if tab.is_active then
		return {
			-- { Background = { Color = 'blue' } },
			{ Text = " " .. title .. " " },
		}
	end

	return {
		{ Text = title .. " | " },
	}
end)

local function create_nvim_key_bind(key, mods, code)
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(win, pane)
			-- local proc = basename(pane:get_foreground_process_name())
			-- if proc ~= "nvim" then
			-- 	win:perform_action(
			-- 		act.SendKey({
			-- 			key = key,
			-- 			mods = mods,
			-- 		}),
			-- 		pane
			-- 	)
			-- 	return
			-- end

			local key_code = NVIM_SPECIAL_LEADER .. code

			win:perform_action(act.SendString(key_code), pane)
		end),
	}
end

local nvim_mappings = {
	create_nvim_key_bind("p", "CTRL|SHIFT", "csp"),
	create_nvim_key_bind("l", "CTRL|SHIFT", "csl"),
	create_nvim_key_bind("i", "CTRL", "ci"),

	create_nvim_key_bind("RightArrow", "SUPER", "mright"),
	create_nvim_key_bind("LeftArrow", "SUPER", "mleft"),
	create_nvim_key_bind("UpArrow", "SUPER", "mup"),
	create_nvim_key_bind("DownArrow", "SUPER", "mdown"),

	create_nvim_key_bind("/", "CTRL|SHIFT", "cs/"),
	-- not working need to fix with this: https://github.com/wez/wezterm/issues/516
	create_nvim_key_bind("/", "SUPER|SHIFT", "ds/"),
}

local config = wezterm.config_builder()

config.check_for_updates = true
-- term = "screen-256color",
config.use_ime = true

config.enable_kitty_keyboard = true

config.tab_max_width = 100

config.debug_key_events = false

----------------
-- Appearance --
----------------
config.window_background_opacity = 0.96

config.font = wezterm.font({
	family = "JetBrainsMono Nerd Font",
	-- disable ligatures
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	weight = "Bold",
})
-- config.font_size = 12.4
config.front_end = "OpenGL"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.cell_width = 0.9
config.max_fps = 120
-- disable italic?

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.enable_scroll_bar = false

config.color_scheme = "Kanagawa (Gogh)"

-------------
-- Domains --
-------------
-- config.unix_domains = {
-- 	{
-- 		name = "unix",
-- 	},
-- }
-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
-- default_gui_startup_args = { "connect", "unix" },

-- Making the domain the default means that every pane/tab/window
-- spawned by wezterm will have its own scope
config.default_domain = "env_spawn"
config.exec_domains = {
	-- Defines a domain called "env_spawn", which spawns inside a SHELL so it can inherit the correct .profile/.zshrc etc
	wezterm.exec_domain("env_spawn", function(cmd)
		-- Generate a new argument array that will launch a
		-- program via /usr/bin/env
		local wrapped = {
			os.getenv("SHELL"),
			"-il",
		}

		local args = cmd.args

		-- Append the requested command
		-- Note that cmd.args may be nil; that indicates that the
		-- default program should be used. Here we're using the
		-- shell defined by the SHELL environment variable.
		if args ~= nil then
			table.insert(wrapped, "-c")

			for _, arg in ipairs(args) do
				table.insert(wrapped, arg)
			end
		end

		-- replace the requested argument array with our new one
		cmd.args = wrapped

		-- and return the SpawnCommand that we want to execute
		return cmd
	end),
}

--------------
-- Keys ---
-----------
config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- LEADER-d activates the debug overlay
	{ key = "d", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },

	-- create a new tab
	{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },

	-- switch tabs
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "{", mods = "LEADER", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER", action = act.MoveTabRelative(1) },

	{ key = "1", mods = "LEADER", action = act({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = act({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = act({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = act({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = act({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = act({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = act({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = act({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = act({ ActivateTab = 8 }) },
	{ key = "q", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },

	-- create splits
	{ key = "v", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "h", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- move between panes
	{ key = "LeftArrow", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "DownArrow", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "UpArrow", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	-- misc
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },

	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
	{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

	-- enter copy mode
	{ key = "PageUp", mods = "LEADER", action = "ActivateCopyMode" },

	-- LauncherMenu
	{
		key = "l",
		mods = "LEADER",
		action = act.ShowLauncher,
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},

	-- reload config
	{
		key = "r",
		mods = "LEADER",
		action = act.ReloadConfiguration,
	},

	-- {
	-- 	key = "b",
	-- 	mods = "LEADER",
	-- 	action = wezterm.action_callback(function(win, pane)
	-- 		wezterm.log_info("Hello from callback!")
	-- 		wezterm.log_info("WindowID:", win:window_id(), "PaneID:", pane:pane_id())
	-- 	end),
	-- },

	-- Switch to a dots workspace
	{
		key = "u",
		mods = "LEADER",
		action = act.SwitchToWorkspace({
			name = "dots",
			spawn = {
				-- args = { "/opt/homebrew/bin/nvim" },
				cwd = wezterm.home_dir .. "/.config/nvim",
			},
		}),
	},

	-- Create a new workspace with a custom name
	{
		key = "s",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
							spawn = {
								cwd = wezterm.home_dir,
							},
						}),
						pane
					)
				end
			end),
		}),
	},

	{
		key = "f",
		mods = "LEADER",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "~/dotfiles/dev/wez-windowizer.sh" },
		}),
	},

	-- https://github.com/wez/wezterm/pull/5025#issuecomment-2491114061
	{
		key = "Delete",
		action = wezterm.action_callback(function(win, pane)
			local proc = pane:get_foreground_process_name()
			if proc ~= "nvim" then
				win:perform_action(
					act.SendKey({
						key = "Delete"
					}),
					pane
				)
				return
			end

			local key_code = utf8.char(0x1b) .. "[3;1~"
			win:perform_action(act.SendString(key_code), pane)
		end),
	},

	-- nvim custom keys
	table.unpack(nvim_mappings),
}

return config
