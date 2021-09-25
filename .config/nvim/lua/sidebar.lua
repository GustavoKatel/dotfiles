local v = require("utils")
local user_profile = require("user_profile")

local sidebar = require("sidebar-nvim")
sidebar.setup({
	open = true,
	initial_width = 40,
	-- update_interval = 100000,
	sections = user_profile.with_profile_table({
		default = { "datetime", "git-status", "lsp-diagnostics", "todos", "containers" },
		test = { "datetime", "git-status", "lsp-diagnostics", "todos", "containers" },
		work = { "datetime", "git-status", "lsp-diagnostics", "containers" },
	}),
	datetime = { clocks = { { name = "Local" }, { tz = "America/Los_Angeles" }, { tz = "Etc/UTC" } } },
})

v.cmd.highlight("link SidebarNvimLspDiagnosticsTotalNumber Normal")
