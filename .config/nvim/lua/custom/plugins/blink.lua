---@module 'blink.cmp'
---@type blink.cmp.Config
return {
	-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
	-- 'super-tab' for mappings similar to vscode (tab to accept)
	-- 'enter' for enter to accept
	-- 'none' for no mappings
	--
	-- All presets have the following mappings:
	-- C-space: Open menu or open docs if already open
	-- C-n/C-p or Up/Down: Select next/previous item
	-- C-e: Hide menu
	-- C-k: Toggle signature help (if signature.enabled = true)
	--
	-- See :h blink-cmp-config-keymap for defining your own keymap
	keymap = {
		preset = "default",

		["<CR>"] = { "accept", "fallback" },

		["<C-Tab>"] = { "show", "fallback" },

		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
	},

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = {
			auto_show = true,
			window = {
				border = "rounded",
			},
		},
		menu = {
			draw = {
				columns = { { "kind_icon" }, { "label", "label_description", "source_name", gap = 1 } },
			},
			border = "rounded",
			winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
		},

		list = { selection = { preselect = false, auto_insert = true } },
	},

	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		per_filetype = {
			sql = { "dadbod", inherit_defaults = true },
			-- optionally inherit from the `default` sources
			-- lua = { "lazydev" },
		},

		providers = {
			dadbod = { name = "dadbod", module = "vim_dadbod_completion.blink" },
		},
	},

	-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
	-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
	-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
	--
	-- See the fuzzy documentation for more information
	fuzzy = { implementation = "prefer_rust_with_warning" },

	term = {
		enabled = false,
	},

	cmdline = {
		enabled = true,
		keymap = { preset = "inherit" },
		completion = {
			menu = { auto_show = true },

			list = { selection = { preselect = false, auto_insert = true } },
		},
	},
}
