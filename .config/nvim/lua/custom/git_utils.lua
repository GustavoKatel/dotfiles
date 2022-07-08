require("gitsigns").setup({
	numhl = true,
	current_line_blame = false,
	current_line_blame_opts = {
		virt_text = false,
	},
})

local M = {}

function M.tab_diff_split()
	vim.cmd("tabnew %")
	vim.cmd("Gvdiffsplit!")
end

vim.cmd("command! GitTabDiff lua require'custom.git_utils'.tab_diff_split()")

return M
