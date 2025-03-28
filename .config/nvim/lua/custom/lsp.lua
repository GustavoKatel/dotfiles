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
local configs = require("custom.lsp_languages")
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

mason_lspconfig.setup_handlers({
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- Default handler (optional)
		local config = configs.make_config(server_name)
		lspconfig[server_name].setup(config)
	end,
	-- You can provide targeted overrides for specific servers.
	-- For example, a handler override for the `rust_analyzer`:
	--["rust_analyzer"] = function()
	--require("rust-tools").setup({})
	--end,

	lua_ls = function()
		local server_name = "lua_ls"
		local config = configs.make_config(server_name)
		lspconfig[server_name].setup(config)
	end,
})

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
