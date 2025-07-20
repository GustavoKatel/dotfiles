local ensure_installed = {
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
}
require("nvim-treesitter").install(ensure_installed)

local fts = {}
for _, lang in ipairs(ensure_installed) do
	for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
		if not vim.tbl_contains(fts, ft) then
			table.insert(fts, ft)
		end
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = fts,
	callback = function()
		vim.treesitter.start()
	end,
})

require("nvim-treesitter-textobjects").setup({
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
			["]f"] = "@function.outer",
			["]]"] = "@class.outer",
			["]p"] = "@parameter.inner",
		},
		goto_next_end = {
			["]m"] = "@function.outer",
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
