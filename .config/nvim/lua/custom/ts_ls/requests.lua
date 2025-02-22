local handler = function(match, query, metadata, info)
	local lenses = {}

	for id, nodes in pairs(match) do
		local name = query.captures[id]
		for _, node in ipairs(nodes) do
			-- `node` was captured by the `name` capture in the match

			local _ = metadata[id] -- Node level metadata

			if name == "request" then
				local row1, col1, row2, col2 = node:range() -- range of the capture

				table.insert(lenses, {
					title = "Run request",
					range = {
						start = { line = row1, character = col1 },
						["end"] = { line = row2, character = col2 },
					},
					command = {
						title = "  Run request",
						command = "ts_ls.request.run",
						arguments = {
							is_hurl = info.ft == "hurl",
						},
					},
				})

				table.insert(lenses, {
					title = "Copy curl",
					range = {
						start = { line = row1, character = col1 },
						["end"] = { line = row2, character = col2 },
					},
					command = {
						title = "  Copy curl",
						command = "ts_ls.request.curl",
						arguments = {
							is_hurl = info.ft == "hurl",
						},
					},
				})
			end
		end
	end

	return lenses
end

return {
	code_lenses = {
		query = "requests",
		commands = {
			{
				command = "ts_ls.request.run",
				callback = function(arguments)
					if arguments.is_hurl then
						vim.cmd.HurlRunnerAt()
						return
					end
					-- vim.cmd.Rest("run")
					require("kulala").run()
				end,
			},
		},
		handler = handler,
	},
	code_actions = {
		query = "requests",
		commands = {
			{
				command = "ts_ls.request.curl",
				callback = function(arguments)
					if arguments.is_hurl then
						vim.notify("Not implemented for hurl", vim.log.levels.ERROR)
						return
					end
					-- vim.cmd.Rest("curl", "yank")
					require("kulala").copy()
				end,
			},
		},
		handler = handler,
	},
}
