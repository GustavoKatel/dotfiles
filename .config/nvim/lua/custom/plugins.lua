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

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = require("custom.plugins.snacks"),
	},

	-- {{{ lsp
	{
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},

	{ "nvimtools/none-ls.nvim" },
	{ "onsails/lspkind-nvim" },
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			hint_prefix = "󰡱 ",
		},
	},
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

	{
		"folke/trouble.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			-- group = true, -- group results by file
		},
	},
	-- }}}

	-- {{{ language support
	-- { "nvim-treesitter/nvim-treesitter" }, -- semantic highlight
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",

		dependencies = { "OXY2DEV/markview.nvim" },
	},
	{ "windwp/nvim-ts-autotag" }, -- auto close html tags using treesitter
	{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
	{ "nvim-treesitter/nvim-treesitter-context" },
	{ "haringsrob/nvim_context_vt" },
	{ "cespare/vim-toml", ft = "toml" },

	-- markdown improved headers colors and visuals
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended
		-- ft = "markdown", -- If you decide to lazy-load anyway

		dependencies = {
			-- You will not need this if you installed the
			-- parsers manually
			-- Or if the parsers are in your $RUNTIMEPATH
			"nvim-treesitter/nvim-treesitter",

			"nvim-tree/nvim-web-devicons",
		},

		opts = require("custom.plugins.markview"),
	},

	{
		"nvim-neotest/neotest",
		dependencies = {
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/nvim-nio",
			-- adapters
			"haydenmeade/neotest-jest",
			"nvim-neotest/neotest-plenary",
			{
				"fredrikaverpil/neotest-golang",
			},
			-- { dir = "~/dev/neotest-go" },
		},
	},

	{ "github/copilot.vim" },
	-- {
	-- 	"CopilotC-Nvim/CopilotChat.nvim",
	-- 	-- branch = "canary",
	-- 	dependencies = {
	-- 		{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
	-- 		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	-- 	},
	-- 	opts = {
	-- 		debug = true, -- Enable debugging
	-- 		-- See Configuration section for rest
	-- 	},
	-- 	-- See Commands section for default commands if you want to lazy load on them
	-- },
	{
		"olimorris/codecompanion.nvim",
		-- tag = "v16.1.0",
		opts = require("custom.plugins.codecompanion").opts,
		init = require("custom.plugins.codecompanion").init,
		dependencies = {
			"zbirenbaum/copilot.lua", -- or github/copilot.vim
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	-- needed for codecompanion diffs
	{
		"echasnovski/mini.diff",
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				-- Disabled by default
				source = diff.gen_source.none(),
			})
		end,
	},
	{ "b0o/schemastore.nvim" },
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
	{ "mfussenegger/nvim-treehopper" },
	{ "google/vim-searchindex" }, -- better search results
	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically

	{
		"stevearc/oil.nvim",
	},

	{ "kevinhwang91/nvim-bqf" },

	{
		"smjonas/live-command.nvim",
		-- live-command supports semantic versioning via Git tags
		-- tag = "2.*",
		config = function()
			require("live-command").setup()
		end,
	},

	{
		"Wansmer/treesj",
		keys = { "<space>m", "<space>j", "<space>s" },
		dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
		config = function()
			require("treesj").setup({--[[ your config ]]
			})
		end,
	},
	-- {
	-- 	"xb-bx/editable-term.nvim",
	-- 	config = true,
	-- },
	-- }}}

	-- {{{ HUD
	{ "lewis6991/gitsigns.nvim" }, -- git information in the buffer lines
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
			-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/665#issuecomment-1745192076
			local config = require("ibl.config").default_config
			require("ibl").setup({
				indent = { tab_char = config.indent.char },
				scope = { enabled = true },
				exclude = {
					buftypes = { "terminal" },
					filetypes = {
						"lspinfo",
						"packer",
						"checkhealth",
						"help",
						"man",
						"mason",
						"oil_preview",
					},
				},
				-- show_current_context = true,
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
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				segments = {
					{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{
						text = { builtin.lnumfunc, " " },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
				},
			})
		end,
	},
	-- smoothiness
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({})

			local neoscroll = require("neoscroll")
			local keymap = {
				["<PageUp>"] = function()
					neoscroll.ctrl_u({ duration = 150 })
				end,
				["<PageDown>"] = function()
					neoscroll.ctrl_d({ duration = 150 })
				end,
			}
			local modes = { "n", "v", "x" }
			for key, func in pairs(keymap) do
				vim.keymap.set(modes, key, func)
			end
		end,
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {
			-- Smear cursor when switching buffers
			smear_between_buffers = true,

			-- Smear cursor when moving within line or to neighbor lines
			smear_between_neighbor_lines = false,

			stiffness = 0.8, -- 0.6      [0, 1]
			trailing_stiffness = 0.5, -- 0.3      [0, 1]
			distance_stop_animating = 0.5, -- 0.1      > 0
			hide_target_hack = false, -- true     boolean
		},
	},
	{ "tzachar/highlight-undo.nvim", opts = {} },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = require("custom.plugins.which-key"),
	},
	-- }}}

	-- {{{ debugging & testing
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "igorlfs/nvim-dap-view", opts = require("custom.plugins.dap-view") },
			-- "rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			-- go delve support
			"leoluz/nvim-dap-go",
		},
	},
	-- }}}

	-- {{{ utils
	{ "tpope/vim-fugitive", dependencies = { { "tpope/vim-rhubarb" } } }, -- some git goodies
	{ "voldikss/vim-floaterm", cmd = { "FloatermToggle" } }, -- floating terminal
	{ "qpkorr/vim-bufkill" }, -- better support for killing buffers
	{ "mbbill/undotree" }, -- undo history on steroids

	{ "rmagatti/auto-session" },

	{
		"stevearc/overseer.nvim",
		opts = require("custom.overseer.opts"),
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
			{ "davesavic/dadbod-ui-yank", ft = { "dbout" }, lazy = true, opts = {} },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIClose",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		ft = { "sql" },
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_execute_on_save = 0
			vim.g.db_ui_use_nvim_notify = 1
		end,
	},
	{
		"Vigemus/iron.nvim",
		cmd = { "IronSend" },
		config = function()
			require("custom.plugins.iron_repl")
		end,
	},
	{
		"jellydn/hurl.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = "hurl",
		opts = require("custom.plugins.hurl"),
	},
	-- {
	-- 	"rest-nvim/rest.nvim",
	-- 	ft = { "http" },
	-- 	init = function()
	-- 		vim.g.rest_nvim = {}
	-- 	end,
	-- },
	{
		"mistweaverco/kulala.nvim",
		ft = { "http" },
		opts = {
			-- enable winbar
			winbar = true,
			default_winbar_panes = { "body", "headers", "headers_body", "script_output", "stats", "verbose" },
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = {
			-- "GitTabDiff",
			"DiffviewOpen",
		},
		opts = require("custom.plugins.diffview"),
	},
	-- }}}

	--user_profile.with_profile_fn("personal", use, { dir = "/Users/gustavokatel/dev/uprofile.nvim" })
	--user_profile.with_profile_fn("work", use, { "GustavoKatel/uprofile.nvim" })
	{
		"folke/edgy.nvim",
		-- dir = "~/dev/edgy.nvim",
		event = "VeryLazy",
		init = function()
			vim.opt.splitkeep = "screen"
		end,
		opts = require("custom.plugins.edgy"),
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		opts = require("custom.plugins.neo-tree"),
	},
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
	-- }}}

	config = {
		ui = { border = "solid" },
	},
})
