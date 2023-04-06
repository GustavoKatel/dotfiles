local luv = vim.loop

local M = {}

M.cursor_hold_timer = nil

local function open_float_diagnostics()
	vim.diagnostic.open_float({
		border = "rounded",
		focusable = false,
		source = true,
		prefix = function(_, i)
			return i .. ". "
		end,
	})
end

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

			open_float_diagnostics()
		end)
	)
end

return M
