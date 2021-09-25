local v = require("utils")

local treesitter_config = require("nvim-treesitter.configs")

treesitter_config.setup({
	ensure_installed = {
		"rust",
		"go",
		"lua",
		"json",
		"python",
		"yaml",
		"bash",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"html",
	},
	highlight = { enable = true, custom_captures = {} },
	autotag = { enable = true },
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
