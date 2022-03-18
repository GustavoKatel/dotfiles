-- some helpers to manage scratches
local v = require("utils")

local M = {}

function M.get_scratch_filename()
	return ".scratches/notes.md"
end

function M.open_scratch_file()
	vim.api.nvim_command("!mkdir -p .scratches")
	vim.api.nvim_command("vsplit " .. M.get_scratch_filename())
end
vim.api.nvim_add_user_command("ScratchOpenSplit", M.open_scratch_file, {})

function M.open_scratch_file_floating()
	local width = 100
	local height = 30

	-- Get the current UI
	local ui = vim.api.nvim_list_uis()[1]

	-- Create the floating window
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = (ui.width / 2) - (width / 2),
		row = (ui.height / 2) - (height / 2),
		anchor = "NW",
		--style = "minimal",
		border = "rounded",
	}
	local win = vim.api.nvim_open_win(0, true, opts)

	vim.api.nvim_command("edit " .. M.get_scratch_filename())

	local bufnr = vim.api.nvim_get_current_buf()

	local closing_keys = { "q", "<ESC>" }

	for _, key in ipairs(closing_keys) do
		vim.keymap.set({ "n" }, key, ":close<CR>", { buffer = bufnr })
	end
end
vim.api.nvim_add_user_command("ScratchOpenFloat", M.open_scratch_file_floating, {})

return M
