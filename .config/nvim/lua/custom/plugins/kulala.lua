return {
	ui = {
		-- enable winbar
		winbar = true,
		default_winbar_panes = { "body", "headers", "headers_body", "script_output", "stats", "verbose", "all" },
		default_view = "headers_body",
	},
	contenttypes = {
		["application/dns-message"] = {
			formatter = { "hexdump", "-c" },
		},
	},
}
