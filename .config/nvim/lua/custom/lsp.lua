local lspconfig = require("lspconfig")

local mason_lspconfig = require("mason-lspconfig")

require("fidget").setup({
	sources = {
		["null-ls"] = {
			-- null-ls creates a progress bar everytime the cursor moves bc of "code_actions" sources, which is very annoying
			ignore = true,
		},
	},
})

-- configs
require("custom.lsp_languages")
require("custom.lsp_on_attach")

require("null-ls").setup({
	debug = false,
	sources = {
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.prettier,
		--require("null-ls").builtins.code_actions.refactoring,
		require("null-ls").builtins.diagnostics.actionlint,
	},
})

--vim.lsp.set_log_level("debug")

-- TODO: remove after this https://github.com/williamboman/mason-lspconfig.nvim/pull/526
vim.lsp.enable("postgres_lsp")

-- better signs in "signcolumn" for diagnostics

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.ERROR] = " ",
		},
	},
})
