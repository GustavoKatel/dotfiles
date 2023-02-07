-- vim:foldlevel=0:

-- {{{ Bootstrap packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	execute("!mkdir -p " .. install_path)
	execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end
-- }}}

local packer = require("packer")

local user_profile = require("custom.uprofile")

-- Install Plugins
packer.startup({
	function(use)
		use({ "wbthomason/packer.nvim" }) -- updates package manager
		-- libs
		use({ "nvim-lua/plenary.nvim" })

		-- {{{ lsp
		use({
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"folke/neodev.nvim",
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
		-- TODO: do we still need this plugin after https://github.com/neovim/neovim/pull/21100
		use({ "theHamsta/nvim-semantic-tokens" })
		-- }}}

		-- {{{ language support
		use({ "nvim-treesitter/nvim-treesitter" }) -- semantic highlight
		use({ "nvim-treesitter/playground" })
		use({ "windwp/nvim-ts-autotag" }) -- auto close html tags using treesitter
		use({ "nvim-treesitter/nvim-treesitter-textobjects" })
		use({ "nvim-treesitter/nvim-treesitter-context" })
		use({ "haringsrob/nvim_context_vt" })
		use({ "cespare/vim-toml" })

		-- markdown improved headers colors and visuals
		use({
			"lukas-reineke/headlines.nvim",
			config = function()
				require("headlines").setup()
			end,
		})

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
		-- }}}

		-- {{{ colorscheme
		-- use {'tomasiser/vim-code-dark'}
		--use({ "navarasu/onedark.nvim" })
		use({ "rebelot/kanagawa.nvim" })
		-- }}}

		-- {{{ editting
		use({
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup()
			end,
		})
		use({
			"windwp/nvim-autopairs", -- auto close brackets, parenthesis etc
			config = function()
				require("nvim-autopairs").setup({})
			end,
		})
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
		use({ "tpope/vim-sleuth" }) -- Detect tabstop and shiftwidth automatically

		use({
			"lambdalisue/fern.vim",
			requires = {
				"TheLeoP/fern-renderer-web-devicons.nvim",
			},
			config = function()
				vim.g["fern#renderer"] = "nvim-web-devicons"
				vim.g["fern#scheme#file#show_absolute_path_on_root_label"] = 1
			end,
		})
		-- }}}

		-- {{{ HUD
		use({ "lewis6991/gitsigns.nvim" }) -- git information in the buffer lines
		use({
			"nvim-tree/nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup()
			end,
		})
		use({ "nvim-lualine/lualine.nvim" })
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup({
					buftype_exclude = { "terminal" },
					filetype_exclude = { "lspinfo", "packer", "checkhealth", "help", "man", "mason", "SidebarNvim" },
					show_current_context = true,
				})
			end,
		})
		use({
			"folke/todo-comments.nvim",
			config = function()
				require("todo-comments").setup({
					highlight = {
						-- pattern or table of patterns, used for highlightng (vim regex)
						pattern = {
							[[.*<(KEYWORDS)\s*:]],
							[[.*<(KEYWORDS)(\(.*\))\s*:]],
						},
					},
					search = {
						pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]], -- ripgrep regex
					},
				})
			end,
		})
		use({ "L3MON4D3/LuaSnip" })
		use({ "stevearc/dressing.nvim" })
		-- }}}

		-- {{{ debugging & testing
		use({ "mfussenegger/nvim-dap" })
		-- use({ "rcarriga/nvim-dap-ui" })
		-- }}}

		-- {{{ utils
		use({ "tpope/vim-fugitive", requires = { { "tpope/vim-rhubarb" } } }) -- some git goodies
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
		-- }}}

		-- {{{ sidebar
		use({
			user_profile.with_profile_table({
				default = "sidebar-nvim/sidebar.nvim",
				test = "/Users/gustavokatel/dev/sidebar.nvim",
				work = "sidebar-nvim/sidebar.nvim",
				jupiter = "sidebar-nvim/sidebar.nvim",
			}),
			rocks = user_profile.with_profile_table({
				default = { "luatz" },
				jupiter = {},
			}),
		})
		use({ "GustavoKatel/dap-sidebar.nvim" })
		--use({ "/Users/gustavokatel/dev/dap-sidebar.nvim" })

		--user_profile.with_profile_fn("personal", use, { "/Users/gustavokatel/dev/uprofile.nvim" })
		--user_profile.with_profile_fn("work", use, { "GustavoKatel/uprofile.nvim" })
		-- }}}

		-- {{{ neovim dev
		use({
			"tpope/vim-scriptease",
			cmd = {
				"Messages", -- view messages in quickfix list
				"Verbose", -- view verbose output in preview window.
				"Time", -- measure how long it takes to run some stuff.
			},
		})
		-- }}}

		use(user_profile.with_profile_table({
			default = { "/Users/gustavokatel/dev/tasks.nvim" },
			work = { "GustavoKatel/tasks.nvim", branch = "sources-overhaul" },
			jupiter = { "GustavoKatel/tasks.nvim", branch = "sources-overhaul" },
		}))
	end,
	config = {
		display = {
			open_fn = require("packer.util").float,
			max_jobs = user_profile.with_profile_table({
				default = 20,
				work = 2,
				jupiter = 10,
			}),
		},
	},
})
