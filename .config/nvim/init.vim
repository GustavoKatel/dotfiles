" Use true colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

call plug#begin()

" auto-complete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" NerdTree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" rust lang
Plug 'rust-lang/rust.vim'

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" gitgutter
Plug 'airblade/vim-gitgutter'

" fugitive
Plug 'tpope/vim-fugitive'

" neomake
Plug 'neomake/neomake'

" mundo (gundo) - undo tree view
Plug 'simnalamburt/vim-mundo'

" NerdCommenter - auto commenter
Plug 'scrooloose/nerdcommenter'

call plug#end()

" line numbers
set number

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" show invisible characters
" set listchars=tab:▸\ ,eol:¬
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
set list

" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = ''
let g:airline_right_sep = '«'
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

let g:airline_theme = 'distinguished'

" Fuzzy search \+t
noremap <leader>t :FZF<CR>

" nerdcommenter
nnoremap <leader>cc NERDComToggleComment
vnoremap <leader>cc NERDComToggleComment
