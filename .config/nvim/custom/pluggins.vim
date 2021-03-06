call plug#begin('~/.config/nvim/plugged')

" language clients and autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

""""" Color schemes
Plug 'tomasiser/vim-code-dark'
Plug 'sainnhe/sonokai'
Plug 'kjssad/quantum.vim'
Plug 'ajmwagar/vim-deus'
""""" END Color schemes

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

" currently using coc-prettier
"Plug 'prettier/vim-prettier'

Plug 'GustavoKatel/vim-workspace'

Plug 'cespare/vim-toml'

Plug 'tpope/vim-fugitive'

Plug 'yggdroot/indentline'

" currently using treesitter + coc-typescript
"Plug 'leafgarland/typescript-vim'
"Plug 'peitalin/vim-jsx-typescript'

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

" testing
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-vimspector.nvim'

"Plug expand('~/Projects/telescope-asynctasks.nvim')
Plug 'GustavoKatel/telescope-asynctasks.nvim'

" Initialize plugin system
call plug#end()

