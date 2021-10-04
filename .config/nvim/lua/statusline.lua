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

lualine.setup({
	options = {
		-- theme = "codedark",
		theme = theme,
		-- theme = "github",
		--theme = 'onedark',
	},
	sections = {
		lualine_c = {
			{
				"filename",
				file_status = true, -- displays file status (readonly status, modified status)
				path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
			},
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
			{ lualine_tab_treesitter },
			{ lualine_lsp_status },
		},
		lualine_x = {},
		-- lualine_y = {require'tabline'.tabline_tabs},
		lualine_y = { tabs.tabline },
		lualine_z = {},
	},
})
