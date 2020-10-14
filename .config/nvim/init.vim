call plug#begin('~/.config/nvim/plugged')

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tomasiser/vim-code-dark'

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'

Plug 'vim-airline/vim-airline'

Plug 'preservim/nerdcommenter'

" autocompletition
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'

" multiple cursors
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'editorconfig/editorconfig-vim'

Plug 'airblade/vim-gitgutter'

Plug 'qpkorr/vim-bufkill'

Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'

Plug 'prettier/vim-prettier'

Plug 'thaerkh/vim-workspace'

Plug 'cespare/vim-toml'

Plug 'tpope/vim-fugitive'

Plug 'yggdroot/indentline'

" native builtin nvim stuff: disabled for now, not currently supported in 0.4
" Plug 'neovim/nvim-lspconfig'

" Initialize plugin system
call plug#end()

set encoding=UTF-8

" Required for operations modifying multiple buffers like rename.
set hidden

" enable mouse support 😛
set mouse=a

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rust-analyzer'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['pyls'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ }

colorscheme codedark

set number
set laststatus=2

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

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" gitgutter update time - this also controls .swp write delay
set updatetime=100

" show airline buffer line
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

let NERDTreeChDirMode=2

" fern show hidden files
let g:fern#default_hidden = 1
let g:fern#renderer = "nerdfont"

let g:sessions_dir = '~/.config/nvim/vim-sessions'

" use ripgrep as source to fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob "!.git"'

let g:workspace_session_directory = $HOME . '/.config/nvim/sessions/'
let g:workspace_persist_undo_history = 0  " enabled = 1 (default), disabled = 0

" sets the window/terminal title based on current dir
set title
augroup dirchange
    autocmd!
    " autocmd DirChanged * let &titlestring=v:event['cwd']
    autocmd DirChanged * let &titlestring=fnamemodify(getcwd(), ':t')
augroup END

" splits window below of the focused one
set splitbelow
" splits window on the right
set splitright

" always keep at least 30 lines on the screen
set scrolloff=30

" enable indent lines
autocmd VimEnter * IndentLinesEnable

autocmd VimEnter * IndentLinesEnable

"""""""""""""""""""""""" FERN stuff

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

"""""""""""""""""""""""" END FERN STUFF

"""""""""""""""""""""""" FORMAT ON SAVE

function! MaybeFormat() abort
    " currently this works only for rust. TODO work on js/ts and python
    if &filetype ==# 'rust'
        call LanguageClient#textDocument_formatting_sync()
    endif
endfunction

autocmd BufWritePre * call MaybeFormat()

"""""""""""""""""""""""" END FORMAT ON SAVE

"""""""""""""""""""""""" KEY BINDINGS
map <C-t> :Fern . -reveal=% -drawer -toggle<CR>

" note that if you are using Plug mapping you should not use `noremap` mappings.
nmap <F5> <Plug>(lcn-menu)
" Or map each action separately
nmap <silent>K <Plug>(lcn-hover)
nmap <silent> <F12> <Plug>(lcn-definition)
nmap <silent> <F2> <Plug>(lcn-rename)
nmap <silent> <F3> <Plug>(lcn-code-lens-action)

map <C-s> :w<CR>

map <C-\> :vsplit<CR>

map <C-b> :Buffers<CR>

map <C-q> :q<CR>

map <C-p> :FZF<CR>

nnoremap <M-Right> <C-I>
nnoremap <M-Left> <C-O>

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
vnoremap <silent> <C-c> "+y

augroup CustomTermMappings
    autocmd!
    " send ctrl+c to kill processes in term buffers
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
    " force close term buffer :BD!
    autocmd TermOpen * nnoremap <buffer> <C-d> :BD!<CR>
    " disable line numbers in terminal
    autocmd TermOpen * execute ":set nonumber"
augroup END

" open terminal in new split

nnoremap <silent> <A-F12> :split<CR>:terminal<CR>i

nnoremap <silent> <C-PageUp> :bprevious<CR>
nnoremap <silent> <C-PageDown> :bnext<CR>

"""""""""""""""""""""""" END KEY BINDINGS
