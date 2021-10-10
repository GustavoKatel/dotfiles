-- Bootstrap packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	execute("!mkdir -p " .. install_path)
	execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

local packer = require("packer")

local user_profile = require("user_profile")

-- Install Plugins
packer.startup(function()
	local use = use or use
	use({ "wbthomason/packer.nvim" }) -- updates package manager
	-- libs
	use({ "nvim-lua/plenary.nvim" })
	-- lsp
	use({ "neovim/nvim-lspconfig" })
	use({ "kabouzeid/nvim-lspinstall" })
	--{{{ lspsaga tests
	--use({ "glepnir/lspsaga.nvim" })
	use({ "tami5/lspsaga.nvim" })
	--use({ "GustavoKatel/lspsaga.nvim" })
	--}}}
	use({ "onsails/lspkind-nvim" })
	use({ "ray-x/lsp_signature.nvim" })
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-emoji",
		},
	})
	use({ "nvim-lua/lsp-status.nvim" })
	-- language support
	use({ "nvim-treesitter/nvim-treesitter" }) -- semantic highlight
	use({ "windwp/nvim-ts-autotag" })
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })
	use({ "romgrk/nvim-treesitter-context" })
	-- colorscheme
	-- use {'tomasiser/vim-code-dark'}
	use({ "marko-cerovac/material.nvim" })
	-- use {'projekt0n/github-nvim-theme'}
	use({ "navarasu/onedark.nvim" })

	-- editting
	use({ "preservim/nerdcommenter" }) -- toggle comment
	use({ "jiangmiao/auto-pairs" }) -- auto close brackets, parenthesis etc
	use({ "mg979/vim-visual-multi" }) -- multiple cursors
	use({ "tpope/vim-surround" })
	use({
		"phaazon/hop.nvim",
		as = "hop",
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({})
		end,
	})
	use({ "https://gitlab.com/yorickpeterse/nvim-window.git" })
	use({ "RRethy/vim-illuminate" }) -- hightlight same word across buffer
	use({ "google/vim-searchindex" }) -- better search results
	use({ "editorconfig/editorconfig-vim" })
	-- HUD
	--use({ "airblade/vim-gitgutter" }) -- git information in the buffer lines
	use({ "lewis6991/gitsigns.nvim" })
	use({ "ryanoasis/vim-devicons" }) -- add support for devicons
	use({ "lambdalisue/nerdfont.vim" }) -- add support for nerdfont
	use({ "kyazdani42/nvim-web-devicons" })
	use({ "hoob3rt/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons" } })
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				buftype_exclude = { "terminal" },
			})
		end,
	})
	use({
		"GustavoKatel/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	})
	-- debugging & testing
	--use({ "puremourning/vimspector" }) -- debugging platform
	use({ "mfussenegger/nvim-dap" })
	use({ "rcarriga/nvim-dap-ui" })
	use({ "Pocco81/DAPInstall.nvim" })
	--use({ "vim-test/vim-test" }) -- better support for running tests
	-- utils
	use({ "tpope/vim-fugitive" }) -- some git goodies
	use({ "voldikss/vim-floaterm" }) -- floating terminal
	use({ "qpkorr/vim-bufkill" }) -- better support for killing buffers
	use({ "mbbill/undotree" }) -- undo history on steroids
	use({ "glepnir/dashboard-nvim" })
	use({ "skywind3000/asynctasks.vim" })
	use({ "skywind3000/asyncrun.vim" })

	-- use {'GustavoKatel/vim-workspace'}
	use({ "rmagatti/auto-session" })

	use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } } })
	--use({ "nvim-telescope/telescope-vimspector.nvim" })
	use({ "nvim-telescope/telescope-dap.nvim" })
	use({ "GustavoKatel/telescope-asynctasks.nvim" })

	use({
		user_profile.with_profile_table({
			default = "/Users/gustavokatel/dev/sidebar.nvim",
			work = "/Users/gustavo/dev/sidebar.nvim",
		}),
		rocks = { "luatz" },
	})
	use({ "GustavoKatel/dap-sidebar.nvim" })
	-- use '/Users/gustavokatel/dev/sidebar.nvim-dev'

	-- neovim dev
	use({
		"tpope/vim-scriptease",
		cmd = {
			"Messages", -- view messages in quickfix list
			"Verbose", -- view verbose output in preview window.
			"Time", -- measure how long it takes to run some stuff.
		},
	})
end)
