vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "#region,#endregion" -- viml and lua use the default marker

local ts_fold_ftypes = { "go", "typescript", "typescriptreact", "javascript", "javascriptreact", "python", "rust" }

vim.api.nvim_create_augroup("custom_fold_marker", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "custom_fold_marker",
	pattern = { "vim", "viml", "lua" },
	command = "setlocal foldmarker='{{{,}}}' | setlocal foldlevel=200",
})
vim.api.nvim_create_autocmd("FileType", {
	group = "custom_fold_marker",
	pattern = ts_fold_ftypes,
	callback = function()
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt.foldlevel = 200
	end,
})

--vim.api.nvim_create_augroup("open_foldes_on_read", { clear = true })
--vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
--group = "open_foldes_on_read",
--pattern = vim.tbl_map(function(ftype)
--return "*." .. ftype
--end, ts_fold_ftypes),
--callback = function()
---- open all folds on read, but only if we're using treesitter
--if vim.opt.foldmethod == "expr" and vim.opt.foldexpr == "nvim_treesitter#foldexpr()" then
--vim.cmd([[ normal zR ]])
--end
--end,
--})
