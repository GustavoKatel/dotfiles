local M = {
	handlers = {
		{
			name = "Docker",
			cmd = "docker",
		},
	},
}

function M.setup()
	for _, handler in ipairs(M.handlers) do
		vim.api.nvim_create_user_command(handler.name, function(cargs)
			local cmd_parts = { handler.cmd }
			for _, arg in ipairs(cargs.fargs) do
				table.insert(cmd_parts, arg)
			end
			local cmd = table.concat(cmd_parts, " ")

			local escaped_cmd = vim.fn.fnameescape(cmd)

			vim.cmd("bot split term://" .. escaped_cmd)

			-- set buf hidden and deletes when leaving the window
			vim.bo.bufhidden = "wipe"

			vim.keymap.set("n", "q", ":quit<CR>", { buffer = 0, silent = true })
		end, {
			nargs = "*",
			desc = "Wrapper for " .. handler.name,
		})
	end
end

return M
