" old airline config {{{
" show airline buffer line
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" show buffer numbers
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'codedark'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.branch = ''

" performance improvement
let g:airline_highlighting_cache = 1

" end old airline config }}}

" show buffer number
let g:lightline#bufferline#show_number = 1
" show filetype icon
let g:lightline#bufferline#enable_devicons = 1
" show unicode symbols instead of ascii
let g:lightline#bufferline#unicode_symbols = 1

let g:lightline = {
      \ 'colorscheme': 'codedark',
       \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranchicon', 'gitbranch' ],
      \             [ 'cocstatus', 'currentfunction', 'readonly', 'customfilename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ [] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction',
      \   'gitbranchicon': 'GitBranchIcon',
      \   'gitbranch': 'FugitiveHead',
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
      \   'customfilename': 'CustomFilename',
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
      \ }

function! GitBranchIcon()
    "let l:branch_name = FugitiveHead()
    "return strlen(l:branch_name) ? '' : ''
    return ''
endfunction

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! CustomFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction
