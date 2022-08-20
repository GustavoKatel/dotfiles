-- Bootstrap packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	execute("!mkdir -p " .. install_path)
	execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

local packer = require("packer")

local user_profile = require("custom.uprofile")

-- Install Plugins
packer.startup({
	function(use)
		use({ "wbthomason/packer.nvim" }) -- updates package manager
		-- libs
		use({ "nvim-lua/plenary.nvim" })

		-- lsp
		use({
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		})

		use({ "jose-elias-alvarez/null-ls.nvim" })
		use({ "onsails/lspkind-nvim" })
		use({ "ray-x/lsp_signature.nvim" })
		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-emoji",
				"hrsh7th/cmp-cmdline",
				"saadparwaiz1/cmp_luasnip",
			},
		})
		use({ "j-hui/fidget.nvim" })
		-- language support
		use({ "nvim-treesitter/nvim-treesitter" }) -- semantic highlight
		use({ "nvim-treesitter/playground" })
		use({ "windwp/nvim-ts-autotag" }) -- auto close html tags using treesitter
		use({ "nvim-treesitter/nvim-treesitter-textobjects" })
		use({ "nvim-treesitter/nvim-treesitter-context" })
		use({ "lewis6991/spellsitter.nvim" })
		use({ "haringsrob/nvim_context_vt" })
		use({ "cespare/vim-toml" })

		use({
			"nvim-neotest/neotest",
			requires = {
				"antoinemadec/FixCursorHold.nvim",
				-- adapters
				"haydenmeade/neotest-jest",
				"nvim-neotest/neotest-plenary",
				"nvim-neotest/neotest-go",
			},
		})

		-- colorscheme
		-- use {'tomasiser/vim-code-dark'}
		--use({ "navarasu/onedark.nvim" })
		use({ "rebelot/kanagawa.nvim" })

		-- editting
		use({
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup()
			end,
		})
		-- use({ "jiangmiao/auto-pairs" }) -- auto close brackets, parenthesis etc
		use({
			"windwp/nvim-autopairs", -- auto close brackets, parenthesis etc
			config = function()
				require("nvim-autopairs").setup({})
			end,
		})
		-- use({ "tpope/vim-surround" })
		use({
			"kylechui/nvim-surround",
			-- "~/dev/nvim-surround",
			config = function()
				require("nvim-surround").setup({
					-- Configuration here, or leave empty to use defaults
				})
			end,
		})
		use({ "tpope/vim-abolish" })
		use({
			"phaazon/hop.nvim",
			as = "hop",
			config = function()
				-- you can configure Hop the way you like here; see :h hop-config
				require("hop").setup({})
			end,
		})
		use({ "RRethy/vim-illuminate" }) -- hightlight same word across buffer
		use({ "google/vim-searchindex" }) -- better search results
		use({ "editorconfig/editorconfig-vim" })
		-- HUD
		use({ "lewis6991/gitsigns.nvim" }) -- git information in the buffer lines
		use({ "kyazdani42/nvim-web-devicons" })
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
		})
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup({
					buftype_exclude = { "terminal" },
					filetype_exclude = { "lspinfo", "packer", "checkhealth", "help", "man", "mason" },
				})
			end,
		})
		use({
			"folke/todo-comments.nvim",
			config = function()
				require("todo-comments").setup({})
			end,
		})
		use({ "L3MON4D3/LuaSnip" })
		use({ "stevearc/dressing.nvim" })
		-- debugging & testing
		--use({ "puremourning/vimspector" }) -- debugging platform
		use({ "mfussenegger/nvim-dap" })
		use({ "rcarriga/nvim-dap-ui" })

		-- utils
		use({ "tpope/vim-fugitive" }) -- some git goodies
		use({ "voldikss/vim-floaterm" }) -- floating terminal
		use({ "qpkorr/vim-bufkill" }) -- better support for killing buffers
		use({ "mbbill/undotree" }) -- undo history on steroids
		use({ "skywind3000/asynctasks.vim" })
		use({ "skywind3000/asyncrun.vim" })
		use({ "ThePrimeagen/harpoon" })

		use({ "rmagatti/auto-session" })

		use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/popup.nvim" } }, branch = "0.1.x" })
		use({ "nvim-telescope/telescope-dap.nvim" })
		use({ "nvim-telescope/telescope-live-grep-args.nvim" })
		use({ "GustavoKatel/telescope-asynctasks.nvim" })

		use({
			user_profile.with_profile_table({
				default = "/Users/gustavokatel/dev/sidebar.nvim",
				work = "sidebar-nvim/sidebar.nvim",
			}),
			rocks = { "luatz" },
		})
		use({ "GustavoKatel/dap-sidebar.nvim" })
		--use({ "/Users/gustavokatel/dev/dap-sidebar.nvim" })

		--user_profile.with_profile_fn("personal", use, { "/Users/gustavokatel/dev/uprofile.nvim" })
		--user_profile.with_profile_fn("work", use, { "GustavoKatel/uprofile.nvim" })

		-- neovim dev
		use({
			"tpope/vim-scriptease",
			cmd = {
				"Messages", -- view messages in quickfix list
				"Verbose", -- view verbose output in preview window.
				"Time", -- measure how long it takes to run some stuff.
			},
		})

		use(user_profile.with_profile_table({
			default = { "/Users/gustavokatel/dev/tasks.nvim" },
			work = { "GustavoKatel/tasks.nvim", branch = "sources-overhaul" },
		}))
	end,
	config = {
		display = {
			open_fn = require("packer.util").float,
		},
	},
})
