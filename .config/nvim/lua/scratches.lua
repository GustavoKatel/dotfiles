-- some helpers to manage scratches
local v = require("utils")

local M = {}

function M.open_scratch_tab()
	v.cmd.tabnew("term://" .. vim.fn.getcwd() .. "//" .. vim.env.SHELL)
	v.cmd.tabmove(0)
	vim.api.nvim_command("!mkdir -p .scratches")
	v.cmd.vsplit(".scratches/notes.md")
end

v.cmd["ScratchOpen"] = M.open_scratch_tab

return M
