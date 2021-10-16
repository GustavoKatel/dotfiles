local v = require("utils")

-- Previously using "airblade/vim-gitgutter", but giving this a try
require("gitsigns").setup({
	numhl = true,
	current_line_blame = false,
	current_line_blame_opts = {
		virt_text = false,
	},
})

local M = {}

function M.tab_diff_split()
	v.cmd.tabnew("%")
	vim.cmd("Gvdiffsplit!")
end

vim.cmd("command! GitTabDiff lua require'git_utils'.tab_diff_split()")

return M