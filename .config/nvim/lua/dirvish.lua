local v = require("utils")

v.v.g.dirvish_mode = 1

function _G.dirvish_get_icon(path)
	if path:sub(-1) == "/" then
		return "📁"
	end

	local icon = require("nvim-web-devicons").get_icon(vim.fn.fnamemodify(path, ":p"), vim.fn.fnamemodify(path, ":e"))

	return icon .. " "
end

vim.cmd([[
call dirvish#add_icon_fn({p -> v:lua.dirvish_get_icon(p) })
]])
