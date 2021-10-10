-- Previously using "airblade/vim-gitgutter", but giving this a try

require("gitsigns").setup({
	numhl = true,
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = false,
	},
})
