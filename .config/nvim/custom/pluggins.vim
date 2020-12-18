call plug#begin('~/.config/nvim/plugged')

" language clients and autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tomasiser/vim-code-dark'

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'

"Plug 'vim-airline/vim-airline'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

Plug 'preservim/nerdcommenter'

" multiple cursors
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'editorconfig/editorconfig-vim'

Plug 'airblade/vim-gitgutter'

Plug 'qpkorr/vim-bufkill'

Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'

"Plug 'prettier/vim-prettier'

Plug 'GustavoKatel/vim-workspace'

Plug 'cespare/vim-toml'

Plug 'tpope/vim-fugitive'

Plug 'yggdroot/indentline'

Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

Plug 'alvan/vim-closetag'

Plug 'tpope/vim-surround'

Plug 'jiangmiao/auto-pairs'

Plug 'mbbill/undotree'

Plug 'mhinz/vim-startify'

Plug 'voldikss/vim-floaterm'

Plug 'equalsraf/neovim-gui-shim'

" asynctasks
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

" airline icons
Plug 'ryanoasis/vim-devicons'

" vimspector
Plug 'puremourning/vimspector'

" better python syntax
Plug 'vim-python/python-syntax'

Plug 'easymotion/vim-easymotion'

Plug 'vim-test/vim-test'

Plug 'RRethy/vim-illuminate'

" shows how many times a searched key appears
Plug 'google/vim-searchindex'

" horizontally center buffer
Plug 'jmckiern/vim-venter'

" native builtin nvim stuff: disabled for now, not currently supported in 0.4
"Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'

" Initialize plugin system
call plug#end()

