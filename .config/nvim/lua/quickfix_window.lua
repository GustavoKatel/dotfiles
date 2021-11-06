
-- open quickfix window at the very bottom of everything
vim.cmd([[
augroup quickfixWindowSettings
autocmd!
autocmd FileType qf wincmd J
augroup END
]])


