" fern show hidden files
let g:fern#default_hidden = 1
let g:fern#renderer = "nerdfont"

function! s:init_fern() abort
  " Add any code to customize fern buffer
  echo "This function is called ON a fern buffer WHEN initialized"
  nmap <buffer><expr>
      \ <Plug>(fern-my-expand-or-collapse)
      \ fern#smart#leaf(
      \   "\<Plug>(fern-action-collapse)",
      \   "\<Plug>(fern-action-expand)",
      \   "\<Plug>(fern-action-collapse)",
      \ )

  nmap <buffer><nowait> <Space> <Plug>(fern-my-expand-or-collapse)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

map <C-t> :Fern . -reveal=% -drawer -toggle<CR>
