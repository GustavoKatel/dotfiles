local M = {}

local function dump_json_buffer_from_command(cmd, bufname)
	local prev_winnr = vim.fn.win_getid(vim.fn.winnr("#"))

	vim.system(cmd, { text = true }, function(job)
		vim.schedule(function()
			local bufnr = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(job.stdout, "\n"))
			-- set readonly
			vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
			vim.api.nvim_buf_set_option(bufnr, "filetype", "json")
			vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
			vim.api.nvim_buf_set_name(bufnr, bufname)

			vim.api.nvim_set_current_win(prev_winnr)
			vim.api.nvim_set_current_buf(bufnr)
		end)
	end)
end

M.container_inspect = function(node)
	vim.notify("Inspecting node: " .. node.id)

	local cmd = { "docker", "inspect", node.container.container_id }

	dump_json_buffer_from_command(cmd, "docker-container-inspect-" .. node.container.container_id)
end

M.container_logs = function(node)
	vim.notify("Inspecting logs for node: " .. node.id)
	local args = { "docker", "logs", "-f", node.container.container_id }

	vim.cmd.wincmd("p")

	local cmd = "term://" .. table.concat(args, " ")
	vim.cmd.edit(cmd)
end

M.container_attach = function(node)
	local prev_winnr = vim.fn.win_getid(vim.fn.winnr("#"))

	vim.ui.input({
		prompt = "Shell to use",
		default = "/bin/sh",
		-- dressing = {
		-- 	relative = "editor"
		-- }
	}, function(input)
		if input ~= nil then
			vim.notify("Attaching to node: " .. node.id)
			local args = { "docker", "exec", "-it", node.container.container_id, input }

			vim.api.nvim_set_current_win(prev_winnr)

			local cmd = "term://" .. table.concat(args, " ")
			vim.cmd.edit(cmd)
		end
	end)
end

M.container_menu = function(node)
	local is_running = node.container.state == "running"

	local options = {}

	if is_running then
		table.insert(options, { text = "Stop", args = { "stop", node.container.container_id } })
	else
		table.insert(options, { text = "Start", args = { "start", node.container.container_id } })
	end
	table.insert(options, { text = "Restart", args = { "restart", node.container.container_id } })

	if is_running then
		table.insert(options, { text = "Remove (force)", args = { "rm", "-f", node.container.container_id } })
	else
		table.insert(options, { text = "Remove", args = { "rm", node.container.container_id } })
	end

	vim.ui.select(options, {
		format_item = function(item)
			return item.text
		end,
	}, function(choice)
		if choice ~= nil then
			local args = choice.args

			table.insert(args, 1, "docker")

			vim.notify("Executing: " .. table.concat(args, " "))
			vim.system(args)
		end
	end)
end


M.image_inspect = function(node)
	vim.notify("Inspecting image: " .. node.id)

	local cmd = { "docker", "inspect", node.image.image_id }

	dump_json_buffer_from_command(cmd, "docker-image-inspect-" .. node.image.image_id)
end

M.volume_inspect = function(node)
	vim.notify("Inspecting volume: " .. node.id)

	local cmd = { "docker", "inspect", node.volume.volume_id }

	dump_json_buffer_from_command(cmd, "docker-volume-inspect-" .. node.volume.volume_id)
end

return M
