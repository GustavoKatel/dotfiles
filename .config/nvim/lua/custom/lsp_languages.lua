-- local lsp_on_attach = require("custom.lsp_on_attach")

local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
vim.lsp.config("*", {
	capabilities = capabilities,
})

M.attached = false

function M.load_local(project)
	local project_lsp = project.lsp

	-- M.configs = vim.tbl_deep_extend("force", M.default_configs, project_lsp)
	if project_lsp then
		for server_name, local_config in pairs(project_lsp) do
			local config = vim.lsp.config[server_name] or {}
			config = vim.tbl_deep_extend("force", config, local_config)

			vim.lsp.config(server_name, config)

			local clients = vim.lsp.get_clients({ name = server_name })
			for _, client in ipairs(clients) do
				client.settings = config.settings
				client:notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, { settings = config.settings })
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
