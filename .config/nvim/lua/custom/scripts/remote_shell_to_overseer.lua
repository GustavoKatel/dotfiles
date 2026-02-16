local overseer = require("overseer")

local M = {}

function M.run(args_str)
	local args = vim.split(args_str, " ")

	local command = args[1]
	table.remove(args, 1)

	local task = overseer.new_task({
		cmd = command,
		args = args,
	})

	task:start()
	overseer.run_action(task, "open sticky")
end

function M.setup()
	vim.api.nvim_create_user_command("Run", function(opts)
		M.run(opts.args)
	end, {
		nargs = "+",
		desc = "Run a remote shell command in overseer",
	})
end

return M
