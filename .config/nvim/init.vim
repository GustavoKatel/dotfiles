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

"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-session'

"Plug 'tpope/vim-obsession'
"Plug 'dhruvasagar/vim-prosession'

Plug 'thaerkh/vim-workspace'

" native builtin nvim stuff: disabled for now, not currently supported in 0.4
" Plug 'neovim/nvim-lspconfig'

" Initialize plugin system
call plug#end()

set encoding=UTF-8

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rust-analyzer'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['/usr/local/bin/pyls'],
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

let g:airline#extensions#tabline#enabled = 1

let NERDTreeChDirMode=2

" fern show hidden files
let g:fern#default_hidden = 1
let g:fern#renderer = "nerdfont"

let g:sessions_dir = '~/.config/nvim/vim-sessions'

" use ripgrep as source to fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob "!.git"'

let g:workspace_session_directory = $HOME . '/.config/nvim/sessions/'
let g:workspace_persist_undo_history = 0  " enabled = 1 (default), disabled = 0

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
map <C-c> :BD<cr>

" toggle workspace - testing
nnoremap <leader>s :ToggleWorkspace<CR>

"""""""""""""""""""""""" END KEY BINDINGS
