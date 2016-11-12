" Use true colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Use cursor shape
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" vim-plug - Install plugins"   {{{
call plug#begin()

" auto-complete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" NerdTree
Plug 'scrooloose/nerdtree' ", { 'on':  'NERDTreeToggle' }

" rust lang
" Plug 'rust-lang/rust.vim' ", { 'for': 'rust' }
Plug 'tarrant/rust.vim'

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
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

" editor config
Plug 'editorconfig/editorconfig-vim'

" Ultisnips - snippets
Plug 'SirVer/ultisnips'

" Clang completition
Plug 'Rip-Rip/clang_complete', { 'for': ['cpp', 'c'], 'do': 'make' }

" vim-json
Plug 'elzr/vim-json', { 'for': 'json' }

" multiple-fucking-cursor
Plug 'terryma/vim-multiple-cursors'

" ident gui
Plug 'Yggdroot/indentLine'

" One dark color scheme
Plug 'joshdick/onedark.vim'

" Vim sintax
Plug 'vim-scripts/fish.vim'

call plug#end() " ------------- }}}


" Personal settings and other custom mappings     "{{{
" line numbers
set number

" show invisible characters
" set listchars=tab:▸\ ,eol:¬
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
set list

" tab spaces
set tabstop=4 shiftwidth=4 expandtab

" delete line in insert mode
imap <c-k> <ESC>ddi

" remove selection after a search (/)
nmap <silent> <esc> :noh<cr>

" set color scheme to onedark
colorscheme onedark

nmap bb :bNext<cr>
nmap BB :bprevious<cr>

"}}}


" Surround to \+[ - asks for the surround key     "{{{
" Normal and visual
nmap <leader>[ ysiw
vmap <leader>[ S

" Removes surrounding
nmap <leader>[d ds
"}}}


" deoplete.  "{{{
let g:deoplete#enable_at_startup = 1
" Use smartcase.
let g:deoplete#enable_smart_case = 1
" deoplete use enter to inser the canditate
set completeopt+=noinsert
"}}}


" airline    "{{{
let g:airline_powerline_fonts = 1

" enable tabline
let g:airline#extensions#tabline#enabled = 1

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

let g:airline_theme = 'distinguished'  "}}}


" Fuzzy search \+t   "{{{
noremap <leader>t :FZF<CR>

"}}}


" nerdcommenter     "{{{
" [cout]<leader>ci NERDComInvertComment
" [cout]<leader>cc NERDComComment
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
"}}}


" Mundo (Gundo)   "{{{
nnoremap <F5> :MundoToggle<CR>
"}}}


" NerdTree    "{{{
" F6 opens a new nerdtree or create a new nerdtree
" nnoremap <F6> :NERDTreeFocus<CR>
nnoremap <F6> :NERDTreeToggle<CR>

" Shift+F6 finds a the current buffer in the tree
nnoremap <F18> :NERDTreeFind<CR>

" Control-F6 closes the nerdtree
" nnoremap <F30> :NERDTreeClose<CR>

" show hidden files
let NERDTreeShowHidden=1
"}}}


" UltiSnips   "{{{
" Open the snips editor in a vertical split
let g:UltiSnipsEditSplit = "vertical"

" Snippets dir
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']
set runtimepath+=~/.config/nvim/UltiSnips

" TabExpander
let g:UltiSnipsExpandTrigger= "<F8>"
let g:UltiSnipsListSnippets = "<F32>" " control-f8
"}}}


" Clang complete   "{{{
let g:clang_library_path='/usr/lib/llvm-3.8/lib/libclang.so.1'
"}}}


" multiple-cursos - use ctrl-d, instead of ctrl-n   "{{{
let g:multi_cursor_next_key='<C-d>'

"}}}


" folding     "{{{
set foldmethod=marker
set foldlevel=99

" Ref: http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
fu! CustomFoldText()
    "get first non-blank line
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
    endwhile

    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif

    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = repeat("+--", v:foldlevel)
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
    let expansionString = repeat(".", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
    return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endf

set foldtext=CustomFoldText()
" use space to toggle the fold, if exists a fold. Fallback to default <space>
" behavior otherwise
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
" create a fold by selecting lines
vnoremap <Space> zf
"}}}
