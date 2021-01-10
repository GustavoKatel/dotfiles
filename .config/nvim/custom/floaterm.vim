command! Ranger FloatermNew ranger

" alt+f12 to toggle term window
nnoremap <silent> <A-F12> :FloatermToggle<CR>
inoremap <silent> <A-F12> <ESC>:FloatermToggle<CR>
tnoremap <silent> <A-F12> <C-\><C-N>:FloatermToggle<CR>
" page up/down to move between terms
tnoremap <silent> <C-PageDown> <C-\><C-N>:FloatermNext<CR>
tnoremap <silent> <C-PageUp> <C-\><C-N>:FloatermPrev<CR>
" alt+n to create a new term
tnoremap <silent> <M-n> <C-\><C-N>:FloatermNew<CR>
" ctrl+q to kill the current term
tnoremap <silent> <C-q> <C-\><C-N>:FloatermKill<CR>
" alt-t to open ranger in a float terminal
nnoremap <silent> <A-t> :Ranger<CR>

" use esc to exite insert mode in terminal
"tnoremap <ESC>   <C-\><C-n>
