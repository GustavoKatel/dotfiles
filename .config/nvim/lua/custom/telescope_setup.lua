local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<c-s>"] = function(prompt_bufnr)
					actions.send_to_qflist(prompt_bufnr)
					vim.api.nvim_command(":copen")
				end,
				["<esc>"] = actions.close,
			},
		},
		-- layout_config = { width_padding = 130, height_padding = 15 }
		layout_config = { horizontal = { width = 230, height = 60 } },
	},
})

require("telescope").load_extension("dap")
require("telescope").load_extension("harpoon")
require("telescope").load_extension("live_grep_args")
