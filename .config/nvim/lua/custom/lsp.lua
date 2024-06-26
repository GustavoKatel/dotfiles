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

-- config that activates keymaps and enables snippet support
local function make_config(server_name)
	-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	capabilities.textDocument.foldingRange = vim.tbl_extend("force", capabilities.textDocument.foldingRange or {}, {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	})

	local config = { capabilities = capabilities }

	local server_config = configs.configs[server_name] or {}

	return vim.tbl_extend("force", server_config, config)
end

mason_lspconfig.setup_handlers({
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- Default handler (optional)
		local config = make_config(server_name)
		lspconfig[server_name].setup(config)
	end,
	-- You can provide targeted overrides for specific servers.
	-- For example, a handler override for the `rust_analyzer`:
	--["rust_analyzer"] = function()
	--require("rust-tools").setup({})
	--end,

	lua_ls = function()
		local server_name = "lua_ls"
		local config = make_config(server_name)
		lspconfig[server_name].setup(config)
	end,
})

-- better signs in "signcolumn" for diagnostics

-- diagnostics sign error
vim.fn.sign_define(
	"DiagnosticSignError",
	{ texthl = "DiagnosticSignError", text = " ", numhl = "DiagnosticSignError" }
)

-- diagnostics sign warn
vim.fn.sign_define("DiagnosticSignWarn", {
	texthl = "DiagnosticSignWarn",
	text = " ",
	numhl = "DiagnosticSignWarn",
})

-- diagnostics sign info
vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = " ", numhl = "DiagnosticSignInfo" })

-- diagnostics sign hint
vim.fn.sign_define("DiagnosticSignHint", {
	texthl = "DiagnosticSignHint",
	text = " ",
	numhl = "DiagnosticSignHint",
})
