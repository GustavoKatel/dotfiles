local sql_queries_handler = function(match, query, metadata, info)
	local lenses = {}

	for id, nodes in pairs(match) do
		local name = query.captures[id]
		for _, node in ipairs(nodes) do
			-- `node` was captured by the `name` capture in the match

			local mt = metadata[id] -- Node level metadata

			if name == "query" then
				local row1, col1, row2, col2 = node:range()
				local arguments = { row1 = row1, col1 = col1, row2 = row2, col2 = col2, bufnr = info.bufnr }

				local lens = {
					title = "Run query",
					range = {
						start = { line = row1, character = col1 },
						["end"] = { line = row2, character = col2 },
					},
					command = {
						title = " Run query",
						command = "ts_ls.run_query",
						arguments = arguments,
					},
				}

				table.insert(lenses, lens)

				arguments = {}
			end
		end
	end

	return lenses
end

local function cb(arguments)
	for _, win in ipairs(vim.fn.win_findbuf(arguments.bufnr)) do
		vim.api.nvim_win_call(win, function()
			vim.api.nvim_win_set_cursor(0, { arguments.row1 + 1, arguments.col1 })
			vim.cmd("normal! v")
			vim.api.nvim_win_set_cursor(0, { arguments.row2 + 1, arguments.col2 })
		end)
	end
	vim.cmd('execute "normal \\<Plug>(DBUI_ExecuteQuery)"')
end

return {
	code_lenses = {
		query = "sql_queries",
		commands = {
			{
				command = "ts_ls.run_query",
				callback = function(arguments)
					cb(arguments)
				end,
			},
		},
		handler = sql_queries_handler,
	},
	code_actions = {
		query = "sql_queries",
		commands = {
			{
				command = "ts_ls.run_query",
				callback = function(arguments)
					cb(arguments)
				end,
			},
		},
		handler = sql_queries_handler,
	},
}
