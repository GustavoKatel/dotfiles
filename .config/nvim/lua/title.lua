local v = require("utils")

v.cmd["UpdateTitle"] = function()
	local titlestring = v.fn.fnamemodify(v.fn.getcwd(), ":t") .. " - NVIM"

	vim.cmd("let &titlestring='" .. titlestring .. "'")
end

v.autocmd("DirChanged", "*", v.cmd.UpdateTitle)
