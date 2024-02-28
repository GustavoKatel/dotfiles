local lualine = require("lualine")
local tabs = require("custom.custom_tabs")

local function lualine_custom_winnr()
	return " " .. vim.fn.winnr()
end

local function lualine_tab_treesitter()
	return require("nvim-treesitter").statusline(200)
end

local function gitsigns_blame()
	local blame_info = vim.b.gitsigns_blame_line_dict

	if not blame_info then
		return "No blame info"
	end

	local text
	if blame_info.author == "Not Committed Yet" then
		text = blame_info.author
	else
		local date_time
		date_time = os.date("%Y-%m-%d", tonumber(blame_info["author_time"]))
		text = string.format("%s, %s - %s", blame_info.author, date_time, blame_info.summary)
	end
	return text
end

local function notes_count()
	if vim.fn.filereadable(".scratches/notes.md") == 1 then
		return " "
	end

	return ""
end

lualine.setup({
	options = {
		-- theme = "codedark",
		--theme = theme,
		-- theme = "github",
		--theme = 'onedark',
		section_separators = "",
		component_separators = "|",
	},
	sections = {
		lualine_b = {},
		lualine_c = {
			{
				"filename",
				file_status = true, -- displays file status (readonly status, modified status)
				path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
			},
			"diagnostics",
			-- "diff",
			{
				"diff",
				source = function()
					-- this is faster!
					return vim.b.gitsigns_status_dict or {}
				end,
			},
		},
		lualine_x = { { lualine_custom_winnr }, "fileformat", "filetype" },
		lualine_y = {},
	},
	inactive_sections = {
		lualine_c = {
			{
				"filename",
				file_status = true, -- displays file status (readonly status, modified status)
				path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
			},
		},
		lualine_x = { { lualine_custom_winnr }, "location" },
	},
	tabline = {
		lualine_a = { tabs.tabline },
		lualine_b = { "branch" },
		lualine_c = {
			notes_count,
			{ "overseer", label = " " },
			-- require("tasks.statusline.running")(),
			--{
			--"filename",
			--file_status = true, -- displays file status (readonly status, modified status)
			--path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
			--},
			--{ lualine_tab_treesitter },
			--{ gitsigns_blame },
			--{ lualine_lsp_status },
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},

	-- winbar = {
	-- 	lualine_a = {},
	-- 	lualine_b = {},
	-- 	lualine_c = {
	-- 		{
	-- 			"filename",
	-- 			file_status = true, -- displays file status (readonly status, modified status)
	-- 			path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
	-- 		},
	-- 	},
	-- 	lualine_x = {},
	-- 	lualine_y = {},
	-- 	lualine_z = {},
	-- },
	--
	-- inactive_winbar = {
	-- 	lualine_a = {},
	-- 	lualine_b = {},
	-- 	lualine_c = {
	-- 		{
	-- 			"filename",
	-- 			file_status = true, -- displays file status (readonly status, modified status)
	-- 			path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
	-- 		},
	-- 	},
	-- 	lualine_x = {},
	-- 	lualine_y = {},
	-- 	lualine_z = {},
	-- },
})
