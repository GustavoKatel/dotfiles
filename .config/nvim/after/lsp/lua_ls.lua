return {
	init_options = { codelenses = { test = true } },
	settings = {
		Lua = {
			hint = {
				enable = true,
			},

			format = {
				-- Use stylua instead
				enable = false,
			},

			completion = {
				callSnippet = "Replace",
			},

			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "use", "hs", "P" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					-- [vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}
