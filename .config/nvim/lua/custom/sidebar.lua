local user_profile = require("custom.uprofile")

local sidebar = require("sidebar-nvim")

-- local tasks_section = require("sidebar-nvim.sections.tasks")

sidebar.setup({
	open = user_profile.with_profile_table({
		default = true,
		jupiter = false,
	}),
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
		default = { "git", "diagnostics", require("dap-sidebar-nvim.breakpoints") },
		test = {
			-- default = {
			-- 	"datetime",
			-- 	require("sidebar-nvim.builtin.datetime"):with({
			-- 		clocks = { { name = "C2: Local" }, { name = "C2: Local2" }, { name = "C2: Local3" } },
			-- 	}),
			-- },
			-- "buffers",
			-- "todos",
			-- "diagnostics",
			-- "git",
			-- "symbols",
			-- "files",
			-- "containers",
		},
		-- work = { "git", "diagnostics", require("dap-sidebar-nvim.breakpoints"), "containers", tasks_section },
	}),
	datetime = { clocks = { { name = "Local" }, { tz = "America/Los_Angeles" }, { tz = "Etc/UTC" } } },
	todos = { initially_closed = true },
	buffers = { sorting = "name", ignore_not_loaded = true },
	files = { follow = false },
	containers = { use_podman = true },

	views = {
		default = {
			sections = {
				"test",
				"test",
				"symbols",
				"containers",
				"datetime",
				"test_interval",
			},
		},
	},
})
