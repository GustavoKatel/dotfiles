local v = require("utils")

-- v.cmd.colorscheme("codedark")
v.v.g.material_style = "darker"
v.v.g.material_disable_terminal = true

--require("material").setup({
--borders = true,
--style = "darker",
--contrast_windows = { -- Specify which windows get the contrasted (darker) background
---- "terminal", -- Darker terminal background
--"packer", -- Darker packer background
--"qf", -- Darker qf list background
--},
--disable = {
---- background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
--term_colors = true, -- Prevent the theme from setting terminal colors
---- eob_lines = false -- Hide the end-of-buffer lines
--},
--})

--v.cmd.colorscheme("material")

vim.g.onedark_style = "warmer"
vim.g.onedark_disable_toggle_style = true -- By default it is false
vim.g.onedark_disable_terminal_colors = true -- By default it is false
require("onedark").setup()

v.cmd.hi("illuminatedWord guibg=#424242")
v.cmd.hi("TreesitterContext guibg=#3e4452")
