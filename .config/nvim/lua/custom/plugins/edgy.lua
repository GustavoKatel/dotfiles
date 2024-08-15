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
	right = {
		{ title = "Hurl Nvim", size = { width = 0.5 }, ft = "hurl-nvim" },
	},
	bottom = {
		-- toggleterm / lazyterm at the bottom with a height of 40% of the screen
		"Trouble",
		{ ft = "qf", title = "QuickFix" },
		{
			ft = "help",
			size = { height = 20 },
			-- only show help buffers
			filter = function(buf)
				return vim.bo[buf].buftype == "help"
			end,
		},
		{ ft = "dbout", title = "DB Out" },
	},
	left = {
		{
			ft = "dbui",
			title = "DBUI",
		},
		{
			ft = "Outline",
			pinned = false,
			open = "Outline",
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
		-- {
		-- 	title = "Docker",
		-- 	ft = "dockerman",
		-- 	pinned = true,
		-- 	open = function()
		-- 		require("custom.dockerman").open()
		-- 	end,
		-- 	wo = {
		-- 		number = false,
		-- 		relativenumber = false,
		-- 	},
		-- },
		{
			title = "Notifications",
			ft = "notifications",
			pinned = true,
			open = function()
				require("custom.notify").open()
			end,
			wo = {
				number = false,
				relativenumber = false,
			},
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
	},
}
