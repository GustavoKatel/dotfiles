call plug#begin('~/.config/nvim/plugged')

" language clients and autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tomasiser/vim-code-dark'

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'

Plug 'vim-airline/vim-airline'

Plug 'preservim/nerdcommenter'

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

Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

Plug 'alvan/vim-closetag'

Plug 'tpope/vim-surround'

Plug 'jiangmiao/auto-pairs'

Plug 'mbbill/undotree'

Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }

Plug 'mhinz/vim-startify'

" native builtin nvim stuff: disabled for now, not currently supported in 0.4
" Plug 'neovim/nvim-lspconfig'

" Initialize plugin system
call plug#end()

set encoding=UTF-8

" Required for operations modifying multiple buffers like rename.
set hidden

" enable mouse support 😛
set mouse=a

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

" gitgutter update time - this also controls .swp write delay
set updatetime=100

" show airline buffer line
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" show buffer numbers
let g:airline#extensions#tabline#buffer_nr_show = 1

" fern show hidden files
let g:fern#default_hidden = 1
let g:fern#renderer = "nerdfont"

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

" incremental substitute + preview
set inccommand=split

" always keep at least 30 lines on the screen
set scrolloff=30

" enable indent lines
autocmd VimEnter * IndentLinesEnable

autocmd VimEnter * IndentLinesEnable

" auto close tags
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx,*.tsx"

" always show sign column (gitgutter)
set signcolumn=yes

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Give more space for displaying messages.
set cmdheight=2

let g:coc_global_extensions = ["coc-highlight", "coc-json", "coc-python", "coc-rust-analyzer", "coc-snippets", "coc-tsserver"]
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

"""""""""""""""""""""""" LSP STUFF

" GoTo code navigation.
nmap <silent> <F12> <Plug>(coc-definition)
imap <silent> <F12> <Plug>(coc-definition)
" Symbol renaming.
nmap <F2> <Plug>(coc-rename)
nmap <silent> <F5> <Plug>(coc-codelens-action)
nmap <silent> <F6> <Plug>(coc-codeaction-line)

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

"""""""""""""""""""""""" END LSP STUFF

"""""""""""""""""""""""" KEY BINDINGS
map <C-t> :Fern . -reveal=% -drawer -toggle<CR>


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
    " disable line numbers in terminal
    autocmd TermOpen * execute ":set nonumber"
augroup END

" open terminal in new split

nnoremap <silent> <A-F12> :split<CR>:terminal<CR>i

" PageUp PageDown to navigate through buffers
nnoremap <silent> <C-PageUp> :bprevious<CR>
nnoremap <silent> <C-PageDown> :bnext<CR>

" ctrl-a in insert mode to select all
inoremap <silent> <C-a> <Esc>ggVG
" ctrl-a in normal mode to select all
nnoremap <silent> <C-a> ggVG

" Toggle Undotree with F4
nnoremap <F4> :UndotreeToggle<cr>

nnoremap <leader>b :enew<CR>

"""""""""""""""""""""""" END KEY BINDINGS
