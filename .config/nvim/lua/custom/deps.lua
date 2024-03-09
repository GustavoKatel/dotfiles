local user_profile = require("custom.uprofile")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_cmd = require("mason.api.command")
local mason_lsp_cmd = require("mason-lspconfig.api.command")

mason.setup()
mason_lspconfig.setup({
	--ensure_installed = servers,
})

local common_pkgs = { "stylua", "node-debug2-adapter", "actionlint", "yamllint" }

local pkgs = user_profile.with_profile_table({
	default = vim.tbl_flatten({
		common_pkgs,
		{
			"luacheck",
			"delve", -- go debugger
		},
	}),
	work = vim.tbl_flatten({ common_pkgs }),
})

-- local servers = { "python", "rust", "typescript", "go", "lua" }
local common_servers = { "lua_ls", "tsserver", "eslint", "dockerls", "jsonls", "bashls", "cssls" }

local servers = user_profile.with_profile_table({
	default = vim.tbl_flatten({
		common_servers,
		{ "gopls", "clangd", "rust_analyzer", "pyright", "golangci-lint-langserver" },
	}),
	work = vim.tbl_flatten(common_servers),
	jupiter = vim.tbl_flatten({
		common_servers,
		{ "gopls", "clangd", "rust_analyzer", "pyright", "taplo", "ansiblels" },
	}),
})

vim.api.nvim_create_user_command("DepsInstall", function()
	mason_cmd.MasonInstall(pkgs)
	mason_lsp_cmd.LspInstall(servers)
	local ui = require("mason.ui")
	ui.set_view("All")
end, {})
