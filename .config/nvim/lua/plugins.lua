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
    local use = use or use
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
    use { 'nvim-treesitter/nvim-treesitter-textobjects' }
    -- colorscheme
    use { 'tomasiser/vim-code-dark' }
    use { 'marko-cerovac/material.nvim' }
    --use { 'projekt0n/github-nvim-theme', config = function()
        --require("github-theme").setup({
            --themeStyle = "dark",
            ---- ... your github-theme config
        --})
    --end}
    -- editting
    use {'preservim/nerdcommenter'} -- toggle comment
    use {'jiangmiao/auto-pairs'} -- auto close brackets, parenthesis etc
    use { 'mg979/vim-visual-multi' } -- multiple cursors
    use { 'tpope/vim-surround' }
    use {
      'phaazon/hop.nvim',
      as = 'hop',
      config = function()
        -- you can configure Hop the way you like here; see :h hop-config
        require'hop'.setup {  }
      end
    }
    use { 'https://gitlab.com/yorickpeterse/nvim-window.git' }
    use { 'RRethy/vim-illuminate' } -- hightlight same word across buffer
    use { 'google/vim-searchindex' } -- better search results
    use {'editorconfig/editorconfig-vim'}
    -- HUD
    use {'airblade/vim-gitgutter'} -- git information in the buffer lines
    use {'ryanoasis/vim-devicons'} -- add support for devicons
    use {'lambdalisue/nerdfont.vim'} -- add support for nerdfont
    use { 'kyazdani42/nvim-web-devicons' }
    use { 'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons'}}
    --use { 'yggdroot/indentline' } -- shows identline
    use { "lukas-reineke/indent-blankline.nvim" }
    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {}
      end
    }
    -- debugging & testing
    use { 'puremourning/vimspector' } -- debugging platform
    --use { 'mfussenegger/nvim-dap' }
    --use { "Pocco81/DAPInstall.nvim" }
    use { 'vim-test/vim-test' } -- better support for running tests
    -- utils
    use {'tpope/vim-fugitive'} -- some git goodies
    --use {'romgrk/barbar.nvim'} -- buffer line bar
    use {'voldikss/vim-floaterm'} -- floating terminal
    use {'qpkorr/vim-bufkill'} -- better support for killing buffers
    use {'mbbill/undotree'} -- undo history on steroids
    use { 'glepnir/dashboard-nvim' }
    use { 'skywind3000/asynctasks.vim' }
    use { 'skywind3000/asyncrun.vim' }

    use {'GustavoKatel/vim-workspace'}

    use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
    use { 'nvim-telescope/telescope-vimspector.nvim' }
    use { 'GustavoKatel/telescope-asynctasks.nvim' }
    
    use '/Users/gustavokatel/dev/sidebar.nvim'
end)

