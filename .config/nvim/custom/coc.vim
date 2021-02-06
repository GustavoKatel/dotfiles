" coc extensions
let g:coc_global_extensions = [
    \ "coc-explorer",
    \ "coc-highlight",
    \ "coc-json",
    \ "coc-pyright",
    \ "coc-rust-analyzer",
    \ "coc-snippets",
    \ "coc-tsserver",
    \ "coc-lua",
    \ "coc-vimlsp",
    \ "coc-prettier",
    \ "coc-go",
    \]

" GoTo code navigation.
nmap <silent> <F12> <Plug>(coc-definition)
imap <silent> <F12> <Plug>(coc-definition)
" Symbol renaming.
nmap <F2> <Plug>(coc-rename)
nmap <silent> <F5> <Plug>(coc-codelens-action)
nmap <silent> <F6> <Plug>(coc-codeaction-line)
nmap <silent> <F7> :CocDiagnostics<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd User CocTerminalOpen :resize +20

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OrganizeImports   :call     CocAction('runCommand', 'editor.action.organizeImport')


nnoremap <C-t> :CocCommand explorer
    \ --toggle
    \ --sources=buffer+,file+<CR>
