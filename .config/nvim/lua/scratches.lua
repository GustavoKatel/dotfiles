-- some helpers to manage scratches
local v = require("utils")
local tabs = require("custom_tabs")

local M = {}

function M.open_scratch_tab()
    v.cmd.tablast()
    v.cmd.tabnew("term://" .. vim.fn.getcwd() .. "//" .. vim.env.SHELL)
    v.cmd.vsplit(".scratches/notes.md")
    tabs.rename("scratch")
end

v.cmd["ScratchOpen"] = M.open_scratch_tab

return M
