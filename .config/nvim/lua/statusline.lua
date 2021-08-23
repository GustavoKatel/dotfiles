local v = require("utils")
local lualine = require('lualine')
local theme = require("statusline_theme")

local function lualine_custom_winnr() return " " .. v.fn.winnr() end

local function lualine_tab_treesitter() return require("nvim-treesitter").statusline(200) end

lualine.setup({
    options = {
        -- theme = "codedark",
        theme = theme
        -- theme = "github",
    },
    sections = {
        lualine_c = {
            {
                'filename',
                file_status = false, -- displays file status (readonly status, modified status)
                path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        },
        lualine_x = {{lualine_custom_winnr}, 'diff', 'fileformat', 'filetype'}
    },
    inactive_sections = {lualine_x = {{lualine_custom_winnr}, 'location'}},
    tabline = {
        lualine_a = {},
        lualine_b = {'branch'},
        lualine_c = {'filename', {lualine_tab_treesitter}},
        lualine_x = {},
        lualine_y = {require'tabline'.tabline_tabs},
        lualine_z = {}
    }
})
