
" ctrl+p files
nnoremap <C-p> :lua require('telescope.builtin').find_files({layout_config = { width_padding = 130, height_padding = 15 }})<CR>

" ctrl+shift+p commands
nnoremap <C-S-P> :lua require('telescope.builtin').commands({layout_config = { width_padding = 130, height_padding = 15 }})<CR>

" ctrl+b buffers
nnoremap <C-b> :lua require('telescope.builtin').buffers({layout_config = { width_padding = 130, height_padding = 15 }})<CR>

" ctrl+shift+f global search
nnoremap <C-S-F> :lua require('telescope.builtin').live_grep({layout_config = { width_padding = 130, height_padding = 15 }})<CR>


nnoremap <C-S-F9> :lua require('telescope').extensions.vimspector.configurations({layout_config = { width_padding = 130, height_padding = 15 }})<CR>

nnoremap <M-F9> :lua require('telescope').extensions.asynctasks.all({layout_config = { width_padding = 130, height_padding = 15 }})<CR>

