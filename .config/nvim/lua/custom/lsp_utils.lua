local luv = vim.loop

local M = {}

M.cursor_hold_timer = nil
M.cursor_hold_waiting_for_move = false

M.current_win_id = nil

local function open_float_diagnostics()
	local _, win_id = vim.diagnostic.open_float({
		border = "rounded",
		focusable = false,
		source = true,
		prefix = function(_, i)
			return i .. ". "
		end,
	})

	M.current_win_id = win_id
end

-- closes the diagnostics window when leaving the current window
vim.api.nvim_create_autocmd({ "WinLeave", "BufWinLeave" }, {
	group = vim.api.nvim_create_augroup("LspDiagnosticsClose", { clear = true }),
	callback = function()
		if M.current_win_id and vim.api.nvim_win_is_valid(M.current_win_id) then
			vim.api.nvim_win_close(M.current_win_id, true)
			M.current_win_id = nil
		end
	end,
})

-- adds a small delay before showing the line diagnostics
M.cursor_hold = function(is_manual)
	local timeout = 300

	if M.cursor_hold_timer then
		M.cursor_hold_timer:stop()
		M.cursor_hold_timer:close()
		M.cursor_hold_timer = nil
	end

	if is_manual then
		open_float_diagnostics()
		return
	end

	if M.cursor_hold_waiting_for_move then
		return
	end

	M.cursor_hold_timer = luv.new_timer()

	M.cursor_hold_timer:start(
		timeout,
		0,
		vim.schedule_wrap(function()
			if M.cursor_hold_timer then
				M.cursor_hold_timer:stop()
				M.cursor_hold_timer:close()
				M.cursor_hold_timer = nil
			end

			M.cursor_hold_waiting_for_move = true

			open_float_diagnostics()
		end)
	)
end

-- unblocks the CursorHold, this will prevent the diagnostics window to keep showing up and closing other floats to appear
M.cursor_moved = function()
	M.cursor_hold_waiting_for_move = false
end

return M
