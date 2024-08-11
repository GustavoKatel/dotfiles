local M = {}

M.node_inspect = function(node)
	print("Inspecting node: " .. node.id)
	print("Name: " .. node.name)
end

M.node_logs = function(node)
	print("Inspecting logs for node: " .. node.id)
	local args = {"docker", "logs", "-f", node.container_id}

	vim.api.nvim_open_win(0, true, {
		split = "right",
		vertical = true,
	})

	vim.cmd.edit("term://" .. table.concat(args, " "))
end

return M
