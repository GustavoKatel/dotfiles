" Use true colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

call plug#begin()

" auto-complete
Plug 'Valloric/YouCompleteMe'

" fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" NerdTree
Plug 'scrooloose/nerdtree' ", { 'on':  'NERDTreeToggle' }

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

" Surround.vim
Plug 'tpope/vim-surround'

" vim-javascript
Plug 'pangloss/vim-javascript'

" editor config
Plug 'editorconfig/editorconfig-vim'

call plug#end()

" line numbers
set number

" show invisible characters
" set listchars=tab:▸\ ,eol:¬
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
set list

" Surround to \+[ - asks for the surround key
" Normal and visual
nmap <leader>[ ysiw
vmap <leader>[ S

" Removes surrounding
nmap <leader>[d ds

" ========================================
" ===         Plugins conf           =====
" ========================================


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
" [cout]<leader>ci NERDComInvertComment
" [cout]<leader>cc NERDComComment
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1


" Mundo (Gundo)
nnoremap <F5> :MundoToggle<CR>


" NerdTree
" F6 opens a new nerdtree or create a new nerdtree
nnoremap <F6> :NERDTreeFocus<CR>

" Shift+F6 finds a the current buffer in the tree
nnoremap <F18> :NERDTreeFind<CR>

" Control-F6 closes the nerdtree
nnoremap <F30> :NERDTreeClose<CR>


