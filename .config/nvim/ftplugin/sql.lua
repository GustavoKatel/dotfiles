local ts_ls = require("custom.ts_ls")
local ts_ls_sql = require("custom.ts_ls.sql_queries")

vim.keymap.set({ "n" }, "<leader>r", function()
	local filename = vim.api.nvim_buf_get_name(0)

	local cursor = vim.api.nvim_win_get_cursor(0)

	local range = {
		start = { line = cursor[1] - 1, character = cursor[2] },
		["end"] = { line = cursor[1], character = cursor[2] },
	}

	local actions =
		ts_ls.fetch_ts_handler(0, "sql", ts_ls_sql.code_actions.query, filename, range, ts_ls_sql.code_actions.handler)

	if #actions == 0 then
		vim.notify("No SQL query found under cursor", vim.log.levels.INFO)
		return
	end

	local arguments = actions[1].command.arguments

	vim.api.nvim_win_call(0, function()
		vim.api.nvim_win_set_cursor(0, { arguments.row1 + 1, arguments.col1 })
		vim.cmd("normal! v")
		vim.api.nvim_win_set_cursor(0, { arguments.row2 + 1, arguments.col2 })
	end)
	vim.cmd('execute "normal \\<Plug>(DBUI_ExecuteQuery)"')
end, { desc = "Run query under cursor" })

vim.keymap.set({ "v" }, "<leader>r", function()
	vim.cmd('execute "normal \\<Plug>(DBUI_ExecuteQuery)"')
end, { desc = "Run query under cursor" })
