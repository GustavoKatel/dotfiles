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
	overrides = function(colors)
		return {
			BlinkCmpMenu = { bg = colors.palette.dragonBlack3 },
			BlinkCmpLabelDetail = { bg = colors.palette.dragonBlack3 },
			BlinkCmpMenuSelection = { bg = colors.palette.waveBlue1 },
			BlinkCmpSource = { fg = colors.palette.dragonBlack5, bg = "" },
		}
	end,
})

vim.cmd.colorscheme("kanagawa-dragon")
