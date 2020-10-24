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
