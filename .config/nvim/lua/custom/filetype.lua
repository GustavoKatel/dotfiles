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

-- Containerfile to use dockerfile ft
vim.filetype.add({
	extension = {
		Containerfile = "dockerfile",
	},
})

-- coffeescript
vim.filetype.add({
	extension = {
		coffee = "coffee",
	},
})

-- psql files are plsql
vim.filetype.add({
	extension = {
		psql = "plsql",
	},
})

-- http files
vim.filetype.add({
	extension = {
		http = "http",
	},
})
