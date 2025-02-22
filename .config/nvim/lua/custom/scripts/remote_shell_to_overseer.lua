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

return M
