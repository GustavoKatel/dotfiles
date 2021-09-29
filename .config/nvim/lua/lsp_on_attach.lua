local lsp_status = require("lsp-status")

local M = {}

-- keymaps
M.on_attach = function(client, bufnr, ...)
	-- completion.on_attach(client, bufnr)
	lsp_status.on_attach(client, bufnr, ...)
    require 'illuminate'.on_attach(client, bufnr, ...)

	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	-- Mappings.
	local opts = { noremap = true, silent = true }

	buf_set_keymap("n", "<F2>", '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)

	buf_set_keymap("n", "<F12>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "<S-F12>", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("i", "<F12>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("i", "<S-F12>", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)

	buf_set_keymap("n", "<F5>", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts)

	buf_set_keymap("n", "<F6>", '<Cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)

	buf_set_keymap("n", "<F7>", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

	buf_set_keymap("n", "K", '<Cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
	buf_set_keymap("n", "<C-k>", '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)

	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		vim.api.nvim_exec(
			[[
    augroup lsp_formatting
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()
    augroup END
    ]],
			false
		)
		-- elseif client.resolved_capabilities.document_range_formatting then
		-- buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end

	vim.api.nvim_exec(
		[[
    augroup lsp_line_diagnostic
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua require'lsp'.cursor_hold()
    augroup END
    ]],
		false
	)

	if client.resolved_capabilities.code_lens then
		vim.api.nvim_exec(
			[[
    augroup lsp_codelens
    autocmd! * <buffer>
    autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
    augroup END
    ]],
			false
		)
	end
end

return M
