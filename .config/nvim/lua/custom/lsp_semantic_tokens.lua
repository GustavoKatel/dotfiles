local M = {}

M.setup = function()
	require("nvim-semantic-tokens").setup({
		preset = "default",
		-- highlighters is a list of modules following the interface of nvim-semantic-tokens.table-highlighter or
		-- function with the signature: highlight_token(ctx, token, highlight) where
		--        ctx (as defined in :h lsp-handler)
		--        token  (as defined in :h vim.lsp.semantic_tokens.on_full())
		--        highlight (a helper function that you can call (also multiple times) with the determined highlight group(s) as the only parameter)
		highlighters = { require("nvim-semantic-tokens.table-highlighter") },
	})
end

-- TODO: move to an aucommand LspAttach
M.on_attach = function(client, bufnr)
	local caps = client.server_capabilities
	if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
		local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
		vim.api.nvim_create_autocmd("TextChanged", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.semantic_tokens_full()
			end,
		})
		-- fire it first time on load as well
		vim.lsp.buf.semantic_tokens_full()
	end
end

vim.cmd.highlight("LspDeprecated", "gui=strikethrough")
-- TODO: highlight other Lsp tokens

return M
