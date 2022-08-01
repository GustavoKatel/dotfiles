local function update_title()
	local titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " - NVIM"

	vim.cmd("let &titlestring='" .. titlestring .. "'")
end

vim.api.nvim_create_user_command("UpdateTitle", update_title, {})

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
	group = vim.api.nvim_create_augroup("titlestring_update", { clear = true }),
	callback = update_title,
})
