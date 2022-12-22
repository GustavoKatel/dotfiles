local pasync = require("plenary.async")
local utils = require("custom.utils")
local lsp_on_attach = require("custom.lsp_on_attach")

local M = {}

M.default_configs = {
	sumneko_lua = {
		init_options = { codelenses = { test = true } },
		settings = {
			Lua = {
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
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	},
	eslint = {
		on_attach = function(client, bufnr, ...)
			-- neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
			-- the resolved capabilities of the eslint server ourselves!
			client.server_capabilities.documentFormattingProvider = true
			client.server_capabilities.documentRangeFormattingProvider = true
			return lsp_on_attach.on_attach(client, bufnr, ...)
		end,
		settings = {
			format = { enable = true }, -- this will enable formatting
		},
	},
	tsserver = {
		on_attach = function(client, bufnr, ...)
			-- TODO: see if it's possible to disable in the tsserver configs 🤷
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			return lsp_on_attach.on_attach(client, bufnr, ...)
		end,
	},
	jsonls = {
		init_options = {
			provideFormatter = false,
		},
		settings = {
			json = {
				validate = { enable = true },
				schemas = {
					{
						fileMatch = { "package.json" },
						url = "https://json.schemastore.org/package.json",
					},
					{
						fileMatch = { "tsconfig.json", "tsconfig.*.json" },
						url = "http://json.schemastore.org/tsconfig",
					},
				},
			},
		},
	},
	gopls = {
		settings = { gopls = {
			buildFlags = { "-tags=runlet_integration_tests" },
		} },
	},
}

M.configs = vim.tbl_deep_extend("force", M.default_configs, {})

-- TODO: need to make sure that the timing of the load is correct
function M.load_local(project)
	local project_lsp = project.lsp

	-- M.configs = vim.tbl_deep_extend("force", M.default_configs, project_lsp)
	if project_lsp then
		vim.notify_once("found local lsp config, but they are not applied. TODO!", vim.log.levels.DEBUG)
	end
end

require("custom.project").register_on_load_handler(function(project)
	M.load_local(project)
end)

return M
