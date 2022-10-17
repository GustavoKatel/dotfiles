function P(...)
	print(vim.inspect(...))
end

function PrintExtmarks(bufnr, namespace_id)
	local marks = vim.api.nvim_buf_get_extmarks(bufnr or 0, namespace_id, 0, -1, { details = true })
	P(marks)
end
