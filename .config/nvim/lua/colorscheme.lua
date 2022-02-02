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

--vim.g.onedark_disable_toggle_style = true -- By default it is false
require("onedark").setup({
	style = "warmer",
	term_colors = false,
	toggle_style_list = { "warmer" },
	toggle_style_key = "<leader>ts",
})
require("onedark").load()
vim.api.nvim_del_keymap("n", "<leader>ts")

v.cmd.hi("illuminatedWord guibg=#424242")
v.cmd.hi("TreesitterContext guibg=#3e4452")

if vim.g.colors_name == "onedark" then
	local colors = require("onedark.colors")
	v.cmd.hi("LspSagaRenameBorder guifg=" .. colors.green)
	v.cmd.hi("LspSagaDiagnosticBorder guifg=" .. colors.purple)
	v.cmd.hi("LspSagaDiagnosticHeader guifg=" .. colors.cyan)
	v.cmd.hi("LspSagaDiagnosticTruncateLine guifg=" .. colors.cyan)
end
