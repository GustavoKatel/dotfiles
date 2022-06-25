--local colors = require("material.colors")
--local theme = require("lualine.themes.material-nvim")
--local theme = require("lualine.themes.onedark")
local theme = require("lualine.themes.catppuccin")

--local white_dimmed_mapping = { onedark = "#8c8c8c", material = "#ababab" }
--local white_dimmed = white_dimmed_mapping[vim.g.colors_name]

--theme.inactive.a.fg = white_dimmed
--theme.inactive.b.fg = white_dimmed
--theme.inactive.c.fg = white_dimmed
--theme.terminal = { a = { fg = colors.black, bg = colors.yellow } }
--theme.command = { a = { fg = colors.black, bg = colors.cyan } }

return theme
