local v = require("utils")
local user_profile = require("uprofile")

local sidebar = require("sidebar-nvim")
sidebar.setup({
	open = true,
	initial_width = 40,
	enable_profile = false,
	hide_statusline = false,
	--section_separator = { "AAAAA", "BBB" },
	sections = user_profile.with_profile_table({
		default = { "git", "diagnostics", require("dap-sidebar-nvim.breakpoints"), "containers" },
		test = {
			"buffers",
			"todos",
			"diagnostics",
			"git",
			"symbols",
			"files",
			"containers",
		},
		work = { "git", "diagnostics", require("dap-sidebar-nvim.breakpoints") },
	}),
	datetime = { clocks = { { name = "Local" }, { tz = "America/Los_Angeles" }, { tz = "Etc/UTC" } } },
	todos = { initially_closed = true },
	buffers = { sorting = "name" },
	files = {},
})

v.cmd.highlight("link SidebarNvimLspDiagnosticsTotalNumber Normal")
