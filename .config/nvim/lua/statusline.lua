local v = require("utils")
local lualine = require("lualine")
local theme = require("statusline_theme")
local tabs = require("custom_tabs")

local function lualine_custom_winnr()
	return " " .. v.fn.winnr()
end

local function lualine_tab_treesitter()
	return require("nvim-treesitter").statusline(200)
end

local function lualine_lsp_status()
	if #vim.lsp.buf_get_clients() > 0 then
		return require("lsp-status").status()
	end

	return "<no lsp>"
end

local function gitsigns_blame()
	local blame_info = vim.b.gitsigns_blame_line_dict

	if not blame_info then
		return nil
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

lualine.setup({
	options = {
		-- theme = "codedark",
		theme = theme,
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
		},
		lualine_x = { { lualine_custom_winnr }, "fileformat", "filetype" },
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
		lualine_a = {},
		lualine_b = { "branch" },
		lualine_c = {
			{
				"filename",
				file_status = true, -- displays file status (readonly status, modified status)
				path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
			},
			--{ lualine_tab_treesitter },
			--{ gitsigns_blame },
			--{ lualine_lsp_status },
		},
		lualine_x = {},
		lualine_y = { tabs.tabline },
		lualine_z = {},
	},
})
