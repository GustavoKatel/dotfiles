local v = require("custom.utils")

local M = {}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	-- Use a sharp border with `FloatBorder` highlights
	border = "single",
})

-- keymaps
M.on_attach = function(client, bufnr, ...)
	-- completion.on_attach(client, bufnr)
	require("illuminate").on_attach(client, bufnr, ...)
	require("lsp_signature").on_attach({
		bind = true, -- This is mandatory, otherwise border config won't get registered.
		handler_opts = {
			border = "single",
		},
	}, bufnr)
	require("custom.lsp_semantic_tokens").on_attach(client, bufnr)

	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	-- Mappings.
	local opts = { noremap = true, silent = true }

	buf_set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

	buf_set_keymap("n", "<F12>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "<S-F12>", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("i", "<F12>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("i", "<S-F12>", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)

	buf_set_keymap("n", "<F5>", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts)

	buf_set_keymap("n", "<F6>", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("v", "<F6>", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)

	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

	--buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

	v.create_autocommands({
		group = { name = "lsp_formatting" },
		buffer = bufnr,
		cmds = {
			{
				events = { "BufWritePre" },
				def = {
					callback = function()
						vim.lsp.buf.format()
					end,
				},
			},
		},
	})

	v.create_autocommands({
		group = { name = "lsp_line_diagnostic" },
		buffer = bufnr,
		cmds = {
			{
				events = "CursorHold",
				def = {
					callback = function()
						require("custom.lsp_utils").cursor_hold()
					end,
				},
			},
		},
	})

	local has_code_lens = client.server_capabilities.codeLensProvider

	if has_code_lens then
		v.create_autocommands({
			group = { name = "lsp_codelens" },
			buffer = bufnr,
			cmds = {
				{
					events = { "BufEnter", "CursorHold", "InsertLeave" },
					def = {

						callback = function()
							vim.lsp.codelens.refresh()
						end,
					},
				},
			},
		})
	end
end

return M
