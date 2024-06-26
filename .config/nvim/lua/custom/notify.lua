local M = {}

function M.setup()
	M.bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("filetype", "notifications", {
		buf = M.bufnr,
	})

	M.ns_id = vim.api.nvim_create_namespace("custom.notify")

	M.setup_highlights()

	M.original_notify = vim.notify
	vim.notify = M.notify
end

function M.setup_highlights()
	-- vim.cmd.highlight({"NotifyTitle", 'guifg = "#ffffff", guibg = "#000000", gui = "bold"' })
	vim.cmd.highlight({ "link", "NotifyLevelDebug", "Normal" })
	vim.cmd.highlight({ "link", "NotifyLevelInfo", "DiagnosticInfo" })
	vim.cmd.highlight({ "link", "NotifyLevelWarn", "DiagnosticWarn" })
	vim.cmd.highlight({ "link", "NotifyLevelError", "DiagnosticError" })
	vim.cmd.highlight({ "link", "NotifyTimestamp", "Comment" })
end

function M.level_to_highlight_group(level)
	local map = {
		[vim.log.levels.INFO] = "NotifyLevelInfo",
		[vim.log.levels.WARN] = "NotifyLevelWarn",
		[vim.log.levels.ERROR] = "NotifyLevelError",
		[vim.log.levels.DEBUG] = "NotifyLevelDebug",
	}

	return map[level] or "NotifyLevelInfo"
end

function M.level_to_str(level)
	local map = {
		[vim.log.levels.INFO] = "INFO",
		[vim.log.levels.WARN] = "WARN",
		[vim.log.levels.ERROR] = "ERROR",
		[vim.log.levels.DEBUG] = "DEBUG",
	}

	return map[level] or "INFO"
end

function M.notify(msg, level, opts)
	local bufnr = M.bufnr
	level = level or vim.log.levels.INFO

	local level_str = string.format("[%s] ", M.level_to_str(level))
	local timestamp = os.date("%H:%M:%S ")

	local line = string.format("%s%s%s", level_str, timestamp, msg)
	vim.api.nvim_set_option_value("modifiable", true, { buf = bufnr })
	vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { line })
	vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })

	local line_index = vim.api.nvim_buf_line_count(M.bufnr) - 1
	vim.api.nvim_buf_add_highlight(bufnr, M.ns_id, M.level_to_highlight_group(level), line_index, 0, #level_str - 1)
	vim.api.nvim_buf_add_highlight(
		bufnr,
		M.ns_id,
		"NotifyTimestamp",
		line_index,
		#level_str,
		#level_str + #timestamp - 1
	)

	local windows = vim.fn.win_findbuf(M.bufnr)
	for _, winnr in ipairs(windows) do
		vim.api.nvim_win_set_cursor(winnr, { vim.api.nvim_buf_line_count(bufnr), 0 })
	end

	M.original_notify(msg, level, opts)
end

function M.open()
	vim.cmd.split()
	vim.api.nvim_win_set_buf(0, M.bufnr)
end

M.setup()

return M
