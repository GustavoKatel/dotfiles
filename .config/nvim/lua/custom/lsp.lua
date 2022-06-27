local luv = vim.loop
local v = require("custom/utils")
local user_profile = require("custom/uprofile")

local lsp_installer = require("nvim-lsp-installer")

-- status in the tabline
local lsp_status = require("lsp-status")
lsp_status.register_progress()

require("fidget").setup({
	sources = {
		["null-ls"] = {
			-- null-ls creates a progress bar everytime the cursor moves bc of "code_actions" sources, which is very annoying
			ignore = true,
		},
	},
})

-- configs
local configs = require("custom/lsp_languages")
local lsp_on_attach = require("custom/lsp_on_attach")

-- local servers = { "python", "rust", "typescript", "go", "lua" }
local servers = user_profile.with_profile_table({
	default = { "sumneko_lua", "tsserver", "eslint", "gopls", "clangd", "rust_analyzer", "pyright" },
	--default = { "efm", "sumneko_lua", "tsserver", "eslint", "gopls", "clangd", "rust_analyzer", "pyright" },
	work = { "sumneko_lua", "tsserver", "eslint" },
})

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.prettier,
		require("null-ls").builtins.code_actions.refactoring,
	},
})

vim.lsp.set_log_level("debug")

-- config that activates keymaps and enables snippet support
local function make_config(server)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}

	local lsp_status_extension = lsp_status.extensions[server]
	local lsp_handlers = nil
	if lsp_status_extension then
		lsp_handlers = lsp_status_extension.setup()
	end

	local config = { capabilities = capabilities, handlers = lsp_handlers, on_attach = lsp_on_attach.on_attach }

	local server_config = configs[server] or {}
	if server_config.on_attach ~= nil then
		config.on_attach = server_config.on_attach
	end

	return vim.tbl_extend("force", server_config, config)
end

lsp_installer.on_server_ready(function(server)
	local config = make_config(server.name)
	--
	-- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
	server:setup(config)
	vim.cmd([[ do User LspAttachBuffers ]])
end)

v.cmd["UpdateLSP"] = function()
	for _, lang in ipairs(servers) do
		v.cmd.LspInstall(lang)
	end
end

v.cmd["UninstallLSP"] = function()
	for _, lang in ipairs(servers) do
		v.cmd.LspUninstall(lang)
	end
end

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
				prefix = function(_, i)
					return i .. ". "
				end,
			})
		end)
	)
end

return M
