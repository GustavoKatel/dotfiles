local M = {}

M.term_bufnr = nil

local function set_autocommand_to_terminal(bufnr)
	local group = "custom_terminal_sticky"

	vim.api.nvim_create_augroup(group, { clear = true })
	vim.api.nvim_create_autocmd({ "TermClose" }, {
		group = group,
		buffer = bufnr,
		callback = function()
			M.term_bufnr = nil
		end,
	})
end

function M.init_or_attach()
	if M.term_bufnr == nil then
		local current_bufnr = vim.api.nvim_get_current_buf()
		local buftype = vim.api.nvim_buf_get_option(current_bufnr, "buftype")

		if buftype == "terminal" then
			M.term_bufnr = current_bufnr
			set_autocommand_to_terminal(current_bufnr)
			vim.notify("terminal set", vim.log.levels.INFO)
		else
			vim.cmd("terminal")
			M.term_bufnr = vim.api.nvim_get_current_buf()
			set_autocommand_to_terminal(M.term_bufnr)
			vim.notify("terminal created", vim.log.levels.INFO)
		end

		return
	end

	vim.cmd("buffer " .. M.term_bufnr)
end

return M
