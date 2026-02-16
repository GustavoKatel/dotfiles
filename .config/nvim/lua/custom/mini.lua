local M = {}

function M.setup()
	require("mini.pairs").setup()

	require("mini.comment").setup()

	M.setup_jump2d()

	require("mini.splitjoin").setup({})
end

function M.setup_jump2d()
	local jump2d = require("mini.jump2d")

	jump2d.setup({
		allowed_windows = {
			current = true,
			not_current = false,
		},

		allowed_lines = {
			blank = false, -- Blank line (not sent to spotter even if `true`)
		},

		spotter = jump2d.gen_spotter.pattern("%w+"),

		view = {
			dim = true,

			n_steps_ahead = 1,
		},

		mappings = {
			start_jumping = "",
		},
	})

	vim.api.nvim_set_hl(
		0,
		"MiniJump2dSpotUnique",
		{ fg = "#ff007c", bold = true, ctermfg = 198, cterm = { bold = true } }
	)
	vim.api.nvim_set_hl(0, "MiniJump2dSpot", { fg = "#00dfff", bold = true, ctermfg = 45, cterm = { bold = true } })
	vim.api.nvim_set_hl(0, "MiniJump2dSpotAhead", { fg = "#2b8db3", ctermfg = 33 })
end

return M
