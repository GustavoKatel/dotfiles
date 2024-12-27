local opts = {
	log = {
		{
			type = "file",
			filename = "overseer.log",
			level = vim.log.levels.INFO,
		},
	},

	component_aliases = {
		-- Most tasks are initialized with the default components
		default = {
			{ "display_duration", detail_level = 2 },
			"on_output_summarize",
			"on_exit_set_status",
			"on_complete_notify",
			"on_result_diagnostics",
			{ "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
		},
	},

	actions = {
		["open sticky"] = {
			desc = "Open the task output in the <leader>t terminal",
			condition = function(task)
				return task:get_bufnr()
			end,
			run = function(task)
				local term = require("custom.terminal")
				local winnr = term.prev_winnr or 0
				if not vim.api.nvim_win_is_valid(winnr) then
					winnr = 0
				end

				vim.api.nvim_win_call(winnr, function()
					task:open_output()
				end)

			end,
		},
	},
}

return opts
