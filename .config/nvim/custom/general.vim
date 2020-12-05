" SETTINGS {{{
set encoding=UTF-8

" set leader to ,
let mapleader = ","

" Required for operations modifying multiple buffers like rename.
set hidden

" enable mouse support 😛
set mouse=a

colorscheme codedark

set number
set laststatus=2

" disable swap files
set noswapfile

" Special chars
" set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
set list

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

syntax on

" gitgutter update time - this also controls .swp write delay
set updatetime=100

set termguicolors

" splits window below of the focused one
set splitbelow
" splits window on the right
set splitright

" incremental substitute + preview
set inccommand=split

" always keep at least 30 lines on the screen
set scrolloff=30

" always show sign column (gitgutter)
set signcolumn=yes

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Give more space for displaying messages.
set cmdheight=2

" spell checking dictionaries, enable/disable with: set [no]spell
set spelllang=en_us,pt_br

" enable current line highlight
set cursorline

" show tab line
set showtabline=2

" enable indent lines
autocmd VimEnter * IndentLinesEnable
" disable indent lines for json files, they're not really useful and very
" buggy due to conflictants conceal settings: https://github.com/Yggdroot/indentLine/issues/140
autocmd BufEnter *.json,*.md IndentLinesDisable
autocmd FileType json IndentLinesDisable

" auto close tags
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx,*.tsx"

"""""" Rust debugging
packadd termdebug
let g:termdebugger="rust-gdb"
let g:termdebug_wide=1

" enable vim-python syntax highlight
let g:python_highlight_all = 1

" better color for illuminate
hi illuminatedWord guibg=#424242
 
" END SETTINGS }}}

" KEYBINDINGS {{{
set foldmethod=marker 

map <C-s> :w<CR>
imap <C-s> <ESC>:w<CR>i

map <C-\> :vsplit<CR>

map <C-q> :q<CR>

nnoremap <M-Right> <C-I>
nnoremap <M-Left> <C-O>

imap <C-_>   <Plug>NERDCommenterInsert
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

" use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" kill buffer without losing split/window
map <C-d> :BD<cr>

" toggle workspace - testing
nnoremap <leader>s :ToggleWorkspace<CR>

" change focus splits using keypad, does not work on every terminal
nnoremap <silent> <C-k6> <c-w>l
nnoremap <silent> <C-k4> <c-w>h
nnoremap <silent> <C-k8> <c-w>k
nnoremap <silent> <C-k2> <c-w>j

" insert mode ctrl+v paste from clipboard
inoremap <silent> <C-v> <ESC>"+pa
" visual mode ctrl+c copy to clipboard
vnoremap <silent> <C-c> "+y
" insert mode ctrl-z undo
inoremap <silent> <C-z> <ESC>ui

augroup CustomTermMappings
    autocmd!
    " send ctrl+c to kill processes in term buffers
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
    " force close term buffer :BD!
    autocmd TermOpen * nnoremap <buffer> <C-d> :BD!<CR>
    " close buffer and split with <C-q>
    autocmd TermOpen * nnoremap <buffer> <C-q> :bd!<CR>
    " disable line numbers in terminal
    autocmd TermOpen * execute ":set nonumber"
augroup END

" open terminal in new split

" PageUp PageDown to navigate through buffers
nnoremap <silent> <C-PageUp> :bprevious<CR>
nnoremap <silent> <C-PageDown> :bnext<CR>

" ctrl-a in insert mode to select all
inoremap <silent> <C-a> <Esc>ggVG
" ctrl-a in normal mode to select all
nnoremap <silent> <C-a> ggVG

" Toggle Undotree with F4
nnoremap <F4> :UndotreeToggle<cr>

" alt-b to create a new buffer in the current split,
nnoremap <M-b> :enew<CR>

" search current file with ctrl+f
nnoremap <C-f> /
inoremap <C-f> <ESC>/
" visual mode searches for the selected text
vnoremap // y/<C-R>=escape(@",'/\')<CR><CR>
vnoremap <C-f> y/<C-R>=escape(@",'/\')<CR><CR>

" visual mode replace the currently selected text
vnoremap <C-h> y:%s/<C-R>=escape(@",'/\')<CR>/

" ctrl+enter in insert mode to create new line below
inoremap <C-CR> <ESC>o
" shift+enter in insert mode to create new line above
inoremap <S-CR> <ESC>O

nnoremap <leader>c :VenterToggle<CR>

" remove search highlight on ESC
noremap <ESC> :noh<CR><ESC>

" fold keys
nnoremap <C-S-]> :foldopen<CR>
nnoremap <C-S-[> :foldclose<CR>
""""""""""""""""""""""" END KEY BINDINGS"}}}
