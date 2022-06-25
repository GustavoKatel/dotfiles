local user_profile = require("custom/uprofile")

local sidebar = require("sidebar-nvim")

sidebar.setup({
	open = true,
	initial_width = 40,
	enable_profile = false,
	hide_statusline = false,
	section_separator = { "-----", "" },
	--section_title_separator = function(section, index)
	--return { index .. "" }
	--end,
	--section_separator = function(section, index)
	--return { "-----" }
	--end,
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
		work = { "git", "diagnostics", require("dap-sidebar-nvim.breakpoints"), "containers" },
	}),
	datetime = { clocks = { { name = "Local" }, { tz = "America/Los_Angeles" }, { tz = "Etc/UTC" } } },
	todos = { initially_closed = true },
	buffers = { sorting = "name", ignore_not_loaded = true },
	files = { follow = false },
})
