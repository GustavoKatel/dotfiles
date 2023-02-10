local M = {}

M.inputs = {
	git_branch = function()
		return vim.fn.systemlist("git branch --show-current")
	end,
}

function M.put(input_name, put_type, after)
	local input = M.inputs[input_name]

	if type(input) == "function" then
		input = input(put_type)
	end

	vim.api.nvim_put(input, put_type, after, true)
end

function M.select_put(put_type, after)
	vim.ui.select(vim.tbl_keys(M.inputs), { prompt = "Select input:" }, function(input_name)
		M.put(input_name, put_type, after)
	end)
end

return M