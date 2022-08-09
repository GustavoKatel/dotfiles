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
	},
	-- Automatically install missing parsers when entering buffer
	auto_install = true,
	highlight = { enable = true, custom_captures = {} },
	autotag = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
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
			goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
			goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
			goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
			goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
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

require("spellsitter").setup()
