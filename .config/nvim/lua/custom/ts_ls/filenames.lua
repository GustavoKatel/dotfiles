local handler = function(match, query, metadata, info)
	local lenses = {}

	for id, nodes in pairs(match) do
		local name = query.captures[id]
		for _, node in ipairs(nodes) do
			-- `node` was captured by the `name` capture in the match

			local mt = metadata[id] -- Node level metadata

			if name == "filename" then
				local row1, col1, row2, col2 = node:range() -- range of the capture

				local filename = vim.treesitter.get_node_text(node, info.bufnr, { metadata = mt })

				local foldermods = metadata.foldermods or ":h"

				local folder = metadata.folder or "%f"
				folder = folder:gsub("%%f", info.filename)
				folder = vim.fn.fnamemodify(folder, foldermods)

				table.insert(lenses, {
					title = "Open file: " .. filename,
					range = {
						start = { line = row1, character = col1 },
						["end"] = { line = row2, character = col2 },
					},
					command = {
						title = " ",
						command = "ts_ls.filenames.openFile",
						arguments = { vim.fs.joinpath(folder, filename) },
					},
				})
			end
		end
	end

	return lenses
end

return {
	code_lenses = {
		query = "filenames",
		commands = {
			{
				command = "ts_ls.filenames.openFile",
				callback = function(arguments)
					vim.cmd("e " .. arguments[1])
				end,
			},
		},
		handler = handler,
	},
	code_actions = {
		query = "filenames",
		commands = {
			{
				command = "ts_ls.filenames.openFile",
				callback = function(arguments)
					vim.cmd("e " .. arguments[1])
				end,
			},
		},
		handler = handler,
	},
}
