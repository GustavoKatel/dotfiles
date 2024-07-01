local M = {}

function M.get_request_at_cursor()
	vim.treesitter.get_parser(0, "lua"):parse()

	local current_node = vim.treesitter.get_node({
		bufnr = 0,
	})
	local start_row, _, end_row, _ = current_node:range()

	local query = vim.treesitter.query.parse("lua", [[
		(request) @request
	]])


	for id, node, metadata, match in query:iter_captures(current_node, 0, start_row, end_row) do
		local text = vim.treesitter.get_node_text(node,0, { metadata = metadata })

		P({text = text, range = {start_row}})
	end
end

return M
