local pasync = require("plenary.async")
local Task = require("tasks.lib.task")

local function wrap_task_terminal(spec)
	return function(ctx)
		local tx, rx = pasync.control.channel.oneshot()

		local env = spec.env or {}

		local env_concat = table.concat(
			vim.tbl_map(function(env_name)
				return env_name .. "=" .. env[env_name]
			end, vim.tbl_keys(env)),
			" "
		)

		if env_concat ~= "" then
			env_concat = env_concat .. " "
		end

		local cmd = table.concat(vim.tbl_flatten({ env_concat, spec.cmd }), " ")

		cmd = "edit term://" .. (spec.cwd or vim.loop.cwd()) .. "//" .. cmd

		local current_window_nr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())

		vim.cmd("2wincmd w")

		vim.cmd(cmd)

		local buffer = vim.api.nvim_get_current_buf()
		local term_id = vim.b.terminal_job_id

		pasync.run(function()
			ctx.stop_request_receiver()
			vim.fn.jobstop(term_id)
		end)

		vim.api.nvim_buf_set_option(buffer, "bufhidden", "hide")

		vim.api.nvim_create_autocmd({ "TermClose" }, {
			buffer = buffer,
			callback = function(event)
				vim.keymap.set({ "n", "t" }, "<CR>", function()
					vim.cmd("bprev")
					vim.cmd("bdelete! " .. buffer)
				end, { buffer = buffer })
				tx(event)
			end,
		})

		if current_window_nr ~= 2 then
			vim.cmd("wincmd p")
		end

		rx()
	end
end

return {
	create_task = function(_, spec, args)
		return Task:new(wrap_task_terminal(spec), nil)
	end,
}
