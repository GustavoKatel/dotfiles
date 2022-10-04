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

function M.load_local()
	pasync.util.block_on(function()
		local config_data = utils.async_read_file(vim.loop.cwd() .. "/.nvim/lsp.json")
		if config_data == nil then
			return
		end

		vim.schedule(function()
			vim.notify("using local lsp config", vim.log.levels.DEBUG)
		end)

		local ok, config = pcall(vim.json.decode, config_data)
		if not ok then
			vim.schedule(function()
				vim.notify(
					string.format("error trying to parse json from '.nvim/lsp.json': %s", config),
					vim.log.levels.ERROR
				)
			end)
			return
		end

		M.configs = vim.tbl_deep_extend("force", M.default_configs, config or {})
	end)
end

--vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--group = vim.api.nvim_create_augroup("lsp_local_project_config_autocmds", { clear = true }),
--desc = "reload lsp custom config",
--pattern = ".nvim/lsp.json",
--callback = function()
--M.load_local(function()
--end)
---- NOTE: restart lsp?
--vim.notify("local lsp loaded", vim.log.levels.DEBUG)
--end,
--})

return M
