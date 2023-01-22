vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 200

vim.api.nvim_create_augroup("custom_fold_marker", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "custom_fold_marker",
	pattern = { "vim", "viml", "lua" },
	command = "setlocal foldmarker={{{,}}} | setlocal foldlevel=200",
})
