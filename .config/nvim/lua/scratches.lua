-- some helpers to manage scratches
local v = require("utils")

local M = {}

function M.open_scratch_file()
	vim.api.nvim_command("!mkdir -p .scratches")
	vim.api.nvim_command("vsplit .scratches/notes.md")
end

vim.api.nvim_add_user_command("ScratchOpenNotes", M.open_scratch_file, {})

return M
