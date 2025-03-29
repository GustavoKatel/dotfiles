local M = {}

M.term_bufnr = nil
M.prev_winnr = nil

local ns = vim.api.nvim_create_namespace("my.terminal.prompt")

local augroup = vim.api.nvim_create_augroup("term_open_config", { clear = true })

-- terminal overrides
-- no line numbers on terminals
vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		vim.cmd("setlocal nonumber")
		vim.cmd("setlocal norelativenumber")
		vim.cmd("setlocal nospell")
	end,
})

-- vim.api.nvim_create_autocmd("TermRequest", {
-- 	group = augroup,
-- 	callback = function(args)
-- 		if string.match(args.data.sequence, "^\027]133;A") then
-- 			vim.opt.signcolumn = "yes"
-- 			local lnum = args.data.cursor[1]
-- 			vim.api.nvim_buf_set_extmark(args.buf, ns, lnum - 1, 0, {
-- 				sign_text = "▶",
-- 				sign_hl_group = "SpecialChar",
-- 			})
-- 		end
-- 	end,
-- })

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
