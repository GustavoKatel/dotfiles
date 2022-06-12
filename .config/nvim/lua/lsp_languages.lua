local lsp_on_attach = require("lsp_on_attach")

--local eslint = {
--lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
--lintStdin = true,
--lintFormats = { "%f:%l:%c: %m" },
--lintIgnoreExitCode = true,
--formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
--formatStdin = true,
--}

local prettier = { formatCommand = "./node_modules/.bin/prettier --stdin-filepath ${INPUT}", formatStdin = true }

local lua_formatter = { formatCommand = "stylua -", formatStdin = true }

local configs = {
	yamlls = {
		settings = {
			yaml = {
				format = false,
			},
		},
	},
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
						[vim.fn.expand("/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/")] = true,
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
	efm = {
		init_options = { documentFormatting = true },
		--TODO: https://github.com/neovim/nvim-lspconfig/pull/1414
		single_file_support = true,
		settings = {
			rootMarkers = { ".git/" },
			languages = {
				lua = { lua_formatter },
				javascript = { prettier },
				typescript = { prettier },
				typescriptreact = { prettier },
				javascriptreact = { prettier },
				["javascript.jsx"] = { prettier },
				["typescript.tsx"] = { prettier },
				yaml = { prettier },
				json = { prettier },
				html = { prettier },
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
