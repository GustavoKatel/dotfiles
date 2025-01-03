local treesitter_config = require("nvim-treesitter.configs")

treesitter_config.setup({
	ensure_installed = {
		"rust",
		"go",
		"lua",
		"vim",
		"json",
		"jsonc",
		"python",
		"yaml",
		"bash",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"html",
		"markdown",
		"markdown_inline",
		"dockerfile",
		"scss",
		"sql",
		"query",
		"toml",
		"regex",
		"vimdoc",
		"http",
		"xml",
		"graphql",
	},
	-- Automatically install missing parsers when entering buffer
	auto_install = true,
	highlight = { enable = true, custom_captures = {} },
	autotag = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<leader>l",
			node_incremental = "l",
			scope_incremental = "grc",
			node_decremental = "L",
		},
	},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
				["]p"] = "@parameter.inner",
			},
			goto_next_end = {
				["]f"] = "@function.outer",
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
				["]P"] = "@parameter.outer",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
				["[p"] = "@parameter.inner",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
				["[P"] = "@parameter.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>k"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>K"] = "@parameter.inner",
			},
		},
	},

	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
})

require("treesitter-context").setup({
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	throttle = true, -- Throttles plugin updates (may improve performance)
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
		default = {
			"class",
			"function",
			"method",
		},
		-- Example for a specific filetype.
		-- If a pattern is missing, *open a PR* so everyone can benefit.
		--   rust = {
		--       'impl_item',
		--   },
	},
})

require("nvim_context_vt").setup({
	-- Override default virtual text prefix
	-- Default: '-->'
	prefix = "  -->",
	disable_ft = { "markdown", "yaml", "json" },
})
