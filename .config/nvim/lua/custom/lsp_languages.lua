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
						-- [vim.fn.stdpath("config") .. "/lua"] = true,
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
				buildFlags = {},
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
				experimentalPostfixCompletions = true,
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
		init_options = {
			command = {
				"golangci-lint",
				"run",
				"--out-format",
				"json",
				-- "--issues-exit-code=1",
				-- "--allow-parallel-runners",
			},
		},
	},
}

M.configs = vim.tbl_deep_extend("force", M.default_configs, {})

-- config that activates keymaps and enables snippet support
function M.make_config(server_name)
	-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	capabilities.textDocument.foldingRange = vim.tbl_extend("force", capabilities.textDocument.foldingRange or {}, {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	})

	local config = { capabilities = capabilities }

	local server_config = M.configs[server_name] or {}

	return vim.tbl_extend("force", server_config, config)
end

M.attached = false

function M.load_local(project)
	local project_lsp = project.lsp

	-- M.configs = vim.tbl_deep_extend("force", M.default_configs, project_lsp)
	if project_lsp then
		for server_name, local_config in pairs(project_lsp) do
			M.configs[server_name] = vim.tbl_deep_extend("force", M.configs[server_name], local_config)

			local config = M.make_config(server_name)

			local clients = vim.lsp.get_clients({ name = server_name })
			for _, client in ipairs(clients) do
				client.settings = config.settings
				client.notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, { settings = config.settings })
			end
		end

		vim.notify("loaded lsp configuration from project.nvim", vim.log.levels.DEBUG)
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_local_config", { clear = true }),
	callback = function()
		if M.attached then
			return
		end

		M.attached = true

		require("custom.project").register_on_load_handler(function(project)
			M.load_local(project)
		end)
	end,
})

return M
