-- https://www.reddit.com/r/neovim/comments/rvwsl3/introducing_filetypelua_and_a_call_for_help/

-- these json files are actually jsonc
vim.filetype.add({
	pattern = {
		[".*/.vscode/.*.json"] = "jsonc",
		["tsconfig.json"] = "jsonc",
		[".eslintrc.json"] = "jsonc",
	},
})

-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
-- 	group = vim.api.nvim_create_augroup("jsonc_ft_detect", { clear = true }),
-- 	pattern = { "*/.vscode/*.json", "tsconfig.json", "tsconfig.monorepo.json", ".eslintrc.json" },
-- 	command = "setlocal filetype=jsonc",
-- })
