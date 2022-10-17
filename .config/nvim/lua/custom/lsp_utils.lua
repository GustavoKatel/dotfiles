local luv = vim.loop

local M = {}

M.cursor_hold_timer = nil

-- adds a small delay before showing the line diagnostics
M.cursor_hold = function()
	local timeout = 500

	if M.cursor_hold_timer then
		M.cursor_hold_timer:stop()
		M.cursor_hold_timer:close()
		M.cursor_hold_timer = nil
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

			vim.diagnostic.open_float({
				border = "rounded",
				focusable = false,
				source = true,
				prefix = function(_, i)
					return i .. ". "
				end,
			})
		end)
	)
end

return M
