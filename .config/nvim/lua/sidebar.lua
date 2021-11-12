local v = require("utils")
local user_profile = require("user_profile")

local sidebar = require("sidebar-nvim")
sidebar.setup({
	open = true,
	initial_width = 40,
	enable_profile = false,
	sections = user_profile.with_profile_table({
		default = {
			"datetime",
			"git-status",
			"lsp-diagnostics",
			"todos",
			"containers",
			require("dap-sidebar-nvim.breakpoints"),
		},
		test = {
			"datetime",
			"git-status",
			"lsp-diagnostics",
		},
		work = {"git-status", "lsp-diagnostics", require("dap-sidebar-nvim.breakpoints"), "files" },
	}),
	datetime = { clocks = { { name = "Local" }, { tz = "America/Los_Angeles" }, { tz = "Etc/UTC" } } },
	todos = { initially_closed = true },
})

v.cmd.highlight("link SidebarNvimLspDiagnosticsTotalNumber Normal")
