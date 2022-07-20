local luv = vim.loop
local v = require("custom/utils")
local user_profile = require("custom/uprofile")
local lspconfig = require("lspconfig")

local lsp_installer = require("nvim-lsp-installer")

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
local common_servers = { "sumneko_lua", "tsserver", "eslint", "dockerls", "jsonls" }

local servers = user_profile.with_profile_table({
	default = vim.tbl_flatten({ common_servers, { "gopls", "clangd", "rust_analyzer", "pyright" } }),
	work = vim.tbl_flatten(common_servers),
})

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.prettier,
		require("null-ls").builtins.code_actions.refactoring,
		require("null-ls").builtins.diagnostics.actionlint.with({
			dynamic_command = require("null-ls.helpers.command_resolver").from_node_modules,
		}),
	},
})

vim.lsp.set_log_level("debug")

-- config that activates keymaps and enables snippet support
local function make_config(server_name)
	-- TODO: still need this?
	--local capabilities = vim.lsp.protocol.make_client_capabilities()
	--capabilities.textDocument.completion.completionItem.snippetSupport = true
	--capabilities.textDocument.completion.completionItem.resolveSupport = {
	--properties = { "documentation", "detail", "additionalTextEdits" },
	--}

	-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

	local config = { capabilities = capabilities, on_attach = lsp_on_attach.on_attach }

	local server_config = configs[server_name] or {}
	if server_config.on_attach ~= nil then
		config.on_attach = server_config.on_attach
	end

	return vim.tbl_extend("force", server_config, config)
end

lsp_installer.setup()

for _, server_name in ipairs(servers) do
	local server = lspconfig[server_name]
	if not server then
		vim.notify("invalid lsp server: " .. server_name, vim.log.levels.ERROR)
	else
		local config = make_config(server_name)
		server.setup(config)
	end
end

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
				focusable = false,
				prefix = function(_, i)
					return i .. ". "
				end,
			})
		end)
	)
end

return M
