local M = {}

M.term_bufnr = nil
M.prev_winnr = nil

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
	if M.term_bufnr == nil or not vim.api.nvim_buf_is_valid(M.term_bufnr) then
		local current_bufnr = vim.api.nvim_get_current_buf()
		local buftype = vim.api.nvim_buf_get_option(current_bufnr, "buftype")

		local channel = vim.api.nvim_buf_get_option(current_bufnr, "channel")
		local is_running = vim.fn.jobwait({ channel }, 0)[1] <= -1

		local is_overseer_task = vim.b[current_bufnr]["overseer_task"] == 1

		if buftype == "terminal" and is_running and not is_overseer_task then
			M.term_bufnr = current_bufnr
			set_autocommand_to_terminal(current_bufnr)
			vim.notify("terminal set", vim.log.levels.INFO)
		else
			vim.cmd("terminal")
			M.term_bufnr = vim.api.nvim_get_current_buf()
			set_autocommand_to_terminal(M.term_bufnr)
			vim.notify("terminal created", vim.log.levels.INFO)
		end

		M.prev_winnr = vim.api.nvim_get_current_win()
		return
	end

	vim.cmd("buffer " .. M.term_bufnr)
	M.prev_winnr = vim.api.nvim_get_current_win()
end

return M
