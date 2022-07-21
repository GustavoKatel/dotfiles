local v = require("custom.utils")

v.cmd["UpdateTitle"] = function()
	local titlestring = v.fn.fnamemodify(v.fn.getcwd(), ":t") .. " - NVIM"

	vim.cmd("let &titlestring='" .. titlestring .. "'")
end

v.autocmd("VimEnter", "*", v.cmd.UpdateTitle)
v.autocmd("DirChanged", "*", v.cmd.UpdateTitle)
