---@type snacks.Config
return {
	notifier = {},
	input = { enabled = true },
	picker = {
		enabled = true,
		ui_select = true,
		jump = {
			reuse_win = false, -- reuse an existing window if the buffer is already open
		},
		win = {
			input = {
				keys = {
					["<Esc>"] = { "close", mode = { "n", "i" } },
					["<c-s>"] = { "qflist", mode = { "i", "n" } },
					["<PageDown>"] = { "list_scroll_down", mode = { "i", "n" } },
					["<PageUp>"] = { "list_scroll_up", mode = { "i", "n" } },
				},
			},
		},
		layouts = {
			default = {
				preset = "default",
				layout = {
					width = 0.5,
					backdrop = false,
				},
			},
			select = {
				preset = "select",
				layout = {
					width = 0.2,
				},
			},
		},
	},
	styles = {
		input = {
			relative = "cursor",
		},
	},
}
