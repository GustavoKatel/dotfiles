local luv = vim.loop
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
local lsp_on_attach = require("custom.lsp_on_attach")

--configs.load_local()

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.prettier,
		--require("null-ls").builtins.code_actions.refactoring,
		require("null-ls").builtins.diagnostics.actionlint.with({
			dynamic_command = require("null-ls.helpers.command_resolver").from_node_modules,
		}),
		require("null-ls").builtins.code_actions.gitsigns,
	},
})

--vim.lsp.set_log_level("debug")

-- config that activates keymaps and enables snippet support
local function make_config(server_name)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}

	-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

	local config = { capabilities = capabilities, on_attach = lsp_on_attach.on_attach }

	local server_config = configs.configs[server_name] or {}
	if server_config.on_attach ~= nil then
		config.on_attach = server_config.on_attach
	end

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
})

local M = {}

M.cursor_hold_timer = nil

-- adds a small delay before showing the line diagnostics
M.cursor_hold = function()
	local timeout = 500

	if M.cursor_hold_timer then
		M.cursor_hold_timer:stop()
		M.cursor_hold_timer:close()
		M.cursor_hold_timer = nil
	end

	M.cursor_hold_timer = luv.new_timer()

	M.cursor_hold_timer:start(
		timeout,
		0,
		vim.schedule_wrap(function()
			if M.cursor_hold_timer then
				M.cursor_hold_timer:stop()
				M.cursor_hold_timer:close()
				M.cursor_hold_timer = nil
			end

			vim.diagnostic.open_float({
				border = "rounded",
				focusable = false,
				source = true,
				prefix = function(_, i)
					return i .. ". "
				end,
			})
		end)
	)
end

-- better signs in "signcolumn" for diagnostics

-- diagnostics sign error
vim.fn.sign_define(
	"DiagnosticSignError",
	{ texthl = "DiagnosticSignError", text = " ", numhl = "DiagnosticSignError" }
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
	text = " ",
	numhl = "DiagnosticSignHint",
})

return M
