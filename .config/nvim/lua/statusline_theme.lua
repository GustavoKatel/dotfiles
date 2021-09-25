local colors = require("material.colors")
local theme = require("lualine.themes.material-nvim")
--local theme = require('lualine.themes.onedark')

local white_dimmed_mapping = { onedark = "#8c8c8c", material = "#ababab" }
local white_dimmed = white_dimmed_mapping[vim.g.colors_name]

theme.inactive.a.fg = white_dimmed
theme.inactive.b.fg = white_dimmed
theme.inactive.c.fg = white_dimmed

return theme
