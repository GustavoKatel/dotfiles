return {
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
}
