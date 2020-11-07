" show airline buffer line
"let g:airline#extensions#tabline#enabled = 1
" Show just the filename
"let g:airline#extensions#tabline#fnamemod = ':t'
" show buffer numbers
"let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'codedark'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.branch = ''

" performance improvement
let g:airline_highlighting_cache = 1


let g:lightline = {
      \ 'colorscheme': 'codedark',
       \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch' ],
      \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction',
      \   'gitbranch': 'FugitiveHead',
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
      \ },
      \ }

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction
