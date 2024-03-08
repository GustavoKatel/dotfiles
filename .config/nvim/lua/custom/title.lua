local function update_title()
	local parent_folder = vim.fn.fnamemodify(vim.fn.fnamemodify(vim.fn.getcwd(), ":h"), ":t")
	local titlestring = parent_folder .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " - NVIM"

	vim.cmd("let &titlestring='" .. titlestring .. "'")
end

vim.api.nvim_create_user_command("UpdateTitle", update_title, {})

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
	group = vim.api.nvim_create_augroup("titlestring_update", { clear = true }),
	callback = update_title,
})
