local actions = require("telescope.actions")

-- local tasks_actions = require("telescope._extensions.tasks.actions")

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
	extensions = {
		-- tasks = {
		-- 	mappings = {
		-- 		specs = {
		-- 			i = {
		-- 				["<c-e>"] = tasks_actions.run_with_runner_opts({ terminal_edit_command = "split" }),
		-- 			},
		-- 		},
		-- 		running = {
		-- 			i = {
		-- 				["<c-b>"] = tasks_actions.open_buffer(),
		-- 			},
		-- 		},
		-- 	},
		-- },
	},
})

require("telescope").load_extension("dap")
require("telescope").load_extension("harpoon")
require("telescope").load_extension("live_grep_args")
-- require("telescope").load_extension("tasks")
require("telescope").load_extension("gh")
