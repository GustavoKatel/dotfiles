local user_profile = require("custom.uprofile")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_cmd = require("mason.api.command")
local mason_lsp_cmd = require("mason-lspconfig.api.command")

mason.setup()
mason_lspconfig.setup({
	--ensure_installed = servers,
})

local common_pkgs = { "stylua", "actionlint", "yamllint", "postgres_lsp", "yamlls", "js-debug-adapter" }

local pkgs = user_profile.with_profile_table({
	default = vim.iter({
		common_pkgs,
		{
			"luacheck",
			"delve", -- go debugger
		},
	})
		:flatten()
		:totable(),
	work = vim.iter({ common_pkgs }):flatten():totable(),
})

-- local servers = { "python", "rust", "typescript", "go", "lua" }
local common_servers =
	{ "lua_ls", "vtsls", "eslint", "dockerls", "jsonls", "bashls", "cssls", "rubocop", "elixir-ls", "zls", "ruby-lsp" }

local servers = user_profile.with_profile_table({
	default = vim.iter({
		common_servers,
		{ "gopls", "clangd", "rust_analyzer", "pyright", "golangci-lint-langserver", "terraform-ls" },
	})
		:flatten()
		:totable(),
	work = vim.iter(common_servers):flatten():totable(),
	jupiter = vim.iter({
		common_servers,
		{ "gopls", "clangd", "rust_analyzer", "pyright", "taplo", "ansiblels" },
	})
		:flatten()
		:totable(),
})

vim.api.nvim_create_user_command("DepsInstall", function()
	mason_cmd.MasonInstall(pkgs)
	mason_lsp_cmd.LspInstall(servers)
	local ui = require("mason.ui")
	ui.set_view("All")
end, {})
