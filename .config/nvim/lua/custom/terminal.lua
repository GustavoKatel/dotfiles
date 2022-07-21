local M = {}

M.term_bufnr = nil

function M.init_or_attach()
	if M.term_bufnr == nil then
		local current_bufnr = vim.api.nvim_get_current_buf()
		local buftype = vim.api.nvim_buf_get_option(current_bufnr, "buftype")

		if buftype == "terminal" then
			M.term_bufnr = current_bufnr
			vim.notify("terminal set", vim.log.levels.INFO)
		else
			vim.cmd("terminal")
			M.term_bufnr = vim.api.nvim_get_current_buf()
			vim.notify("terminal created", vim.log.levels.INFO)
		end

		return
	end

	vim.cmd("buffer " .. M.term_bufnr)
end

return M
