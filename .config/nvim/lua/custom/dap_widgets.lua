local widgets = require("dap.ui.widgets")

local M = {}

M.setup = function()
	M.scopes = widgets.sidebar(widgets.scopes, {}, "split")
	M.sessions = widgets.sidebar(widgets.sessions, {}, "vsplit")
end

M.open_all = function()
	M.scopes.open()
end

M.close_all = function()
	M.scopes.close()
end

M.toggle_all = function()
	M.scopes.toggle()
end

return M
