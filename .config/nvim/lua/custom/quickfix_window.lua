-- open quickfix window at the very bottom of everything
-- vim.cmd([[
-- augroup quickfixWindowSettings
-- autocmd!
-- autocmd FileType qf wincmd J
-- augroup END
-- ]])

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("quickfixWindowSettings", { clear = true }),
	pattern = { "qf" },
	desc = "move quickfix window to the bottom",
	command = "wincmd J",
})
