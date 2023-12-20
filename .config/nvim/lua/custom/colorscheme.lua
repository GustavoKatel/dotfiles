vim.g.material_style = "darker"
vim.g.material_disable_terminal = true

require("kanagawa").setup({
	colors = {
		theme = {
			all = {
				ui = {
					bg_gutter = "none",
				},
			},
		},
	},
})

vim.cmd.colorscheme("kanagawa-dragon")
