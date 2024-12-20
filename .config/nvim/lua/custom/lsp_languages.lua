-- local lsp_on_attach = require("custom.lsp_on_attach")

local M = {}

M.default_configs = {
	lua_ls = {
		init_options = { codelenses = { test = true } },
		settings = {
			Lua = {
				hint = {
					enable = true,
				},

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
			-- return lsp_on_attach.on_attach(client, bufnr, ...)
		end,
		settings = {
			format = { enable = true }, -- this will enable formatting
		},
	},
	vtsls = {
		on_attach = function(client, bufnr, ...)
			-- TODO: see if it's possible to disable in the vtsls configs 🤷
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			-- return lsp_on_attach.on_attach(client, bufnr, ...)
		end,
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},
	jsonls = {
		init_options = {
			provideFormatter = true,
		},
		settings = {
			json = {
				validate = { enable = true },
				schemas = {
					{
						fileMatch = { "package.json" },
						uri = "https://json.schemastore.org/package.json",
					},
					{
						fileMatch = { "tsconfig.json", "tsconfig.*.json" },
						uri = "http://json.schemastore.org/tsconfig",
					},
					{
						fileMatch = { "**/*/.nvim/project.json" },
						uri = "file://" .. vim.fn.stdpath("config") .. "/schemas/project.json",
					},
				},
			},
		},
	},
	gopls = {
		settings = {
			gopls = {
				buildFlags = { "-tags=runlet_integration_tests" },
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
				codelenses = {
					gc_details = true,
					generate = true,
					regenerate_cgo = true,
					run_govulncheck = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
			},
		},
	},
	golangci_lint_ls = {
		settings = {
			init_options = {
				command = {
					"golangci-lint",
					"run",
					"--enable-all",
					"--disable",
					"lll",
					"--out-format",
					"json",
					"--issues-exit-code=1",
					"--allow-parallel-runners",
				},
			},
		},
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
