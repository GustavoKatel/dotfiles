-- Bootstrap packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('mkdir -p '..install_path)
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

local packer = require('packer')

-- Install Plugins
packer.startup(function()
    use {'wbthomason/packer.nvim'} -- updates package manager
    -- lsp
    --use {'neovim/nvim-lspconfig'}
    --use { 'kabouzeid/nvim-lspinstall' }
    --use {'nvim-lua/completion-nvim'}
    use { 'neoclide/coc.nvim', branch = "release" }
    -- language support
    use { 'cespare/vim-toml' }
    use {'nvim-treesitter/nvim-treesitter'} -- semantic highlight
    use { 'windwp/nvim-ts-autotag' }
    -- colorscheme
    -- use {'drewtempelmeyer/palenight.vim', config='vim.cmd[[colorscheme palenight]]'}
    use { 'tomasiser/vim-code-dark' }
    use { 'marko-cerovac/material.nvim' }
    -- editting
    use {'preservim/nerdcommenter'} -- toggle comment
    use {'jiangmiao/auto-pairs'} -- auto close brackets, parenthesis etc
    use { 'mg979/vim-visual-multi' } -- multiple cursors
    use { 'tpope/vim-surround' }
    use { 'easymotion/vim-easymotion' }
    use { 'RRethy/vim-illuminate' } -- hightlight same word across buffer
    use { 'google/vim-searchindex' } -- better search results
    use {'editorconfig/editorconfig-vim'}
    --use { 'alvan/vim-closetag' }
    -- HUD
    use {'airblade/vim-gitgutter'} -- git information in the buffer lines
    use {'ryanoasis/vim-devicons'} -- add support for devicons
    use {'lambdalisue/nerdfont.vim'} -- add support for nerdfont
    use { 'kyazdani42/nvim-web-devicons' }
    use { 'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons'}}
     use { 'yggdroot/indentline' } -- shows identline
    -- debugging & testing
    use { 'puremourning/vimspector' } -- debugging platform
    use { 'vim-test/vim-test' } -- better support for running tests
    -- utils
    use {'tpope/vim-fugitive'} -- some git goodies
    use {'romgrk/barbar.nvim'} -- buffer line bar
    use {'voldikss/vim-floaterm'} -- floating terminal
    use {'qpkorr/vim-bufkill'} -- better support for killing buffers
    use {'mbbill/undotree'} -- undo history on steroids
    use {'mhinz/vim-startify'} -- startup page
    use { 'skywind3000/asynctasks.vim' }
    use { 'skywind3000/asyncrun.vim' }

    use {'GustavoKatel/vim-workspace'}
    
    use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
    use { 'nvim-telescope/telescope-vimspector.nvim' }
    use { 'GustavoKatel/telescope-asynctasks.nvim' }
end)

