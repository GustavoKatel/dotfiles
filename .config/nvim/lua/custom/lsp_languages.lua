local lsp_on_attach = require("custom.lsp_on_attach")

local configs = {
	sumneko_lua = {
		init_options = { codelenses = { test = true } },
		settings = {
			Lua = {
				format = {
					-- Use stylua instead
					enable = false,
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
			-- TODO: remove this when 0.8 is out
			if vim.fn.has("nvim-0.8") == 0 then
				client.resolved_capabilities.document_formatting = true
			end
			return lsp_on_attach.on_attach(client, bufnr, ...)
		end,
		settings = {
			format = { enable = true }, -- this will enable formatting
		},
	},
	tsserver = {
		on_attach = function(client, bufnr, ...)
			-- TODO: remove this after 0.8
			-- or see if it's possible to disable in the tsserver configs 🤷
			if vim.fn.has("nvim-0.8") == 1 then
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			else
				client.resolved_capabilities.document_formatting = false
			end
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

return configs
