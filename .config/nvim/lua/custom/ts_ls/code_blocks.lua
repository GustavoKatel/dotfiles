local code_block_handler = function(match, query, metadata, info)
	local lenses = {}
	local arguments = {}

	for id, nodes in pairs(match) do
		local name = query.captures[id]
		for _, node in ipairs(nodes) do
			-- `node` was captured by the `name` capture in the match

			local mt = metadata[id] -- Node level metadata

			if name == "code_fence_language" then
				local ft = vim.treesitter.get_node_text(node, info.bufnr, { metadata = mt })
				arguments.ft = ft
			end

			if name == "code_fence_content" then
				local code = vim.treesitter.get_node_text(node, info.bufnr, { metadata = mt })

				arguments.code = code
			end

			if name == "code_fence" then
				local row1, col1, row2, col2 = node:range() -- range of the capture

				local lens = {
					title = "Run code block",
					range = {
						start = { line = row1, character = col1 },
						["end"] = { line = row2, character = col2 },
					},
					command = {
						title = "",
						command = "ts_ls.run_code_block",
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

return {
	code_lenses = {
		query = "code_blocks",
		commands = {
			{
				command = "ts_ls.run_code_block",
				callback = function(arguments)
					require("iron.core").send(arguments.ft, arguments.code)
				end,
			},
		},
		handler = code_block_handler,
	},
	code_actions = {
		query = "code_blocks",
		commands = {
			{
				command = "ts_ls.run_code_block",
				callback = function(arguments)
					require("iron.core").send(arguments.ft, arguments.code)
				end,
			},
		},
		handler = code_block_handler,
	},
}
