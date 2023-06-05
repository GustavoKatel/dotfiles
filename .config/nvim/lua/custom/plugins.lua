-- vim:foldlevel=0:

-- {{{ Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- }}}

local user_profile = require("custom.uprofile")

-- Install Plugins
require("lazy").setup({
	-- libs
	{ "nvim-lua/plenary.nvim" },

	-- {{{ lsp
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"folke/neodev.nvim",
	},

	{ "jose-elias-alvarez/null-ls.nvim" },
	{ "onsails/lspkind-nvim" },
	-- { "ray-x/lsp_signature.nvim" },
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{ "j-hui/fidget.nvim" },
	{ "lvimuser/lsp-inlayhints.nvim", branch = "anticonceal" },
	-- }}}

	-- {{{ language support
	{ "nvim-treesitter/nvim-treesitter" }, -- semantic highlight
	{ "nvim-treesitter/playground" },
	{ "windwp/nvim-ts-autotag" }, -- auto close html tags using treesitter
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{ "nvim-treesitter/nvim-treesitter-context" },
	{ "haringsrob/nvim_context_vt" },
	{ "cespare/vim-toml" },

	-- markdown improved headers colors and visuals
	{
		"lukas-reineke/headlines.nvim",
		config = function()
			require("headlines").setup()
		end,
	},

	-- {
	-- 	"nvim-neotest/neotest",
	-- 	dependencies = {
	-- 		"antoinemadec/FixCursorHold.nvim",
	-- 		-- adapters
	-- 		"haydenmeade/neotest-jest",
	-- 		"nvim-neotest/neotest-plenary",
	-- 		"nvim-neotest/neotest-go",
	-- 	},
	-- },

	{ "github/copilot.vim" },
	-- }}}

	-- {{{ colorscheme
	-- {'tomasiser/vim-code-dark'},
	--{ "navarasu/onedark.nvim" },
	{ "rebelot/kanagawa.nvim" },
	-- }}}

	-- {{{ editting
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"windwp/nvim-autopairs", -- auto close brackets, parenthesis etc
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"kylechui/nvim-surround",
		-- "~/dev/nvim-surround",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{ "tpope/vim-abolish" },
	{
		"phaazon/hop.nvim",
		name = "hop",
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({})
		end,
	},
	{ "RRethy/vim-illuminate" }, -- hightlight same word across buffer
	{ "google/vim-searchindex" }, -- better search results
	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically

	{ "stevearc/oil.nvim" },
	-- }}}

	-- {{{ HUD
	{ "lewis6991/gitsigns.nvim" }, -- git information in the buffer lines
	{
		"lewis6991/satellite.nvim",
		config = function()
			require("satellite").setup()
			vim.cmd("highlight! link ScrollView CursorColumn")
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup()
		end,
	},
	{ "nvim-lualine/lualine.nvim" },
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				buftype_exclude = { "terminal" },
				filetype_exclude = {
					"lspinfo",
					"packer",
					"checkhealth",
					"help",
					"man",
					"mason",
					"SidebarNvim",
					"oil_preview",
				},
				show_current_context = true,
			})
		end,
	},
	{
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
	},
	{ "L3MON4D3/LuaSnip" },
	{ "stevearc/dressing.nvim" },
	-- }}}

	-- {{{ debugging & testing
	{ "mfussenegger/nvim-dap" },
	-- { "rcarriga/nvim-dap-ui" },
	-- }}}

	-- {{{ utils
	{ "tpope/vim-fugitive", dependencies = { { "tpope/vim-rhubarb" } } }, -- some git goodies
	{ "voldikss/vim-floaterm" }, -- floating terminal
	{ "qpkorr/vim-bufkill" }, -- better support for killing buffers
	{ "mbbill/undotree" }, -- undo history on steroids
	{ "skywind3000/asynctasks.vim" },
	{ "skywind3000/asyncrun.vim" },
	{ "ThePrimeagen/harpoon" },

	{ "rmagatti/auto-session" },

	{ "nvim-telescope/telescope.nvim", dependencies = { { "nvim-lua/popup.nvim" } }, branch = "0.1.x" },
	{ "nvim-telescope/telescope-dap.nvim" },
	{ "nvim-telescope/telescope-live-grep-args.nvim" },
	{ "GustavoKatel/telescope-asynctasks.nvim" },
	{ "nvim-telescope/telescope-github.nvim" },
	-- }}}

	-- {{{ sidebar
	user_profile.with_profile_table({
		default = { "sidebar-nvim/sidebar.nvim" },
		test = { dir = "/Users/gustavokatel/dev/sidebar.nvim" },
	}),

	{ "GustavoKatel/dap-sidebar.nvim" },
	--{ dir = "/Users/gustavokatel/dev/dap-sidebar.nvim" },

	--user_profile.with_profile_fn("personal", use, { dir = "/Users/gustavokatel/dev/uprofile.nvim" })
	--user_profile.with_profile_fn("work", use, { "GustavoKatel/uprofile.nvim" })
	-- }}}

	-- {{{ neovim dev
	{
		"tpope/vim-scriptease",
		cmd = {
			"Messages", -- view messages in quickfix list
			"Verbose", -- view verbose output in preview window.
			"Time", -- measure how long it takes to run some stuff.
		},
	},
	-- }}}

	-- {{{ misc
	{ "rest-nvim/rest.nvim" },
	-- }}}

	user_profile.with_profile_table({
		default = { dir = "/Users/gustavokatel/dev/tasks.nvim" },
		work = { "GustavoKatel/tasks.nvim", branch = "sources-overhaul" },
		jupiter = { "GustavoKatel/tasks.nvim", branch = "sources-overhaul" },
	}),
	config = {
		ui = { border = "solid" },
	},
})
