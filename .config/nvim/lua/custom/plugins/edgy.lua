return {
	options = {
		left = { size = 40 },
		bottom = { size = 10 },
		right = { size = 30 },
		top = { size = 10 },
	},
	animate = {
		enabled = false,
	},
	keys = {
		-- the default action for <c-q> is to hide the window, close instead
		["<c-q>"] = function(win)
			win:close()
		end,
	},
	right = {
		{ title = "Hurl Nvim", size = { width = 0.5 }, ft = "hurl-nvim" },
	},
	bottom = {
		-- toggleterm / lazyterm at the bottom with a height of 40% of the screen
		"Trouble",
		{
			title = "QUICKFIX LIST",
			filter = function(_, win)
				return vim.fn.getwininfo(win)[1]["loclist"] ~= 1
			end,
			ft = "qf",
		},
		-- {
		-- 	title = "LOCATION LIST",
		-- 	filter = function(_, win)
		-- 		return vim.fn.getwininfo(win)[1]["loclist"] == 1
		-- 	end,
		-- 	ft = "qf",
		-- },
		{
			ft = "help",
			size = { height = 20 },
			-- only show help buffers
			filter = function(buf)
				return vim.bo[buf].buftype == "help"
			end,
			-- Indicate in the windbar which help file is currently open
			title = function()
				local bufname = vim.api.nvim_buf_get_name(0)
				bufname = vim.fn.fnamemodify(bufname, ":t")
				return string.format("HELP: %s", bufname)
			end,
		},
		{ ft = "dbout", title = "DB Out" },
		{ ft = "dap-view", title = "DAP View", wo = { winbar = false } },
		{ ft = "dap-view-term", title = "DAP View", wo = { winbar = false } },
		{ ft = "dap-repl", title = "DAP View", wo = { winbar = false } },
		{
			title = "DAP Scopes",
			ft = "",
			filter = function(buf, win)
				local buf_name = vim.api.nvim_buf_get_name(buf) or ""
				buf_name = vim.fn.fnamemodify(buf_name, ":t")
				return vim.startswith(buf_name, "dap-scopes-")
			end,
		},
	},
	left = {
		{
			ft = "dbui",
			title = "DBUI",
		},
		{
			title = "Neo-Tree Git",
			ft = "neo-tree",
			filter = function(buf)
				return vim.b[buf].neo_tree_source == "git_status"
			end,
			pinned = true,
			open = "Neotree position=right git_status",
		},
		{
			title = "Task: History",
			ft = "OverseerList",
			pinned = true,
			open = "OverseerOpen! left",
		},
		{
			title = "Neo-Tree Buffers",
			ft = "neo-tree",
			filter = function(buf)
				return vim.b[buf].neo_tree_source == "buffers"
			end,
			pinned = false,
			open = "Neotree position=top buffers",
		},
		-- any other neo-tree windows
		"neo-tree",
		{
			title = "DAP Sessions",
			ft = "",
			pinned = true,
			open = function()
				require("custom.dap_widgets").sessions.open()
			end,
			filter = function(buf, win)
				local buf_name = vim.api.nvim_buf_get_name(buf) or ""
				buf_name = vim.fn.fnamemodify(buf_name, ":t")
				return vim.startswith(buf_name, "dap-sessions-")
			end,
		},
	},
}
