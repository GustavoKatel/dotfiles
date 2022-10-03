-- these json files are actually jsonc
vim.filetype.add({
	pattern = {
		[".*/.vscode/.*.json"] = "jsonc",
		["tsconfig.json"] = "jsonc",
		[".eslintrc.json"] = "jsonc",
	},
})

-- .env - extra files extensions
vim.filetype.add({
	pattern = {
		[".env.*"] = "sh",
	},
})
