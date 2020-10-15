
GuiFont JetBrainsMono Nerd Font Mono:h10
GuiTabline 0
GuiPopupmenu 0

" neovim-qt context menu - testing
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
