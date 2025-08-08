local M = {}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("custom_lsp_attach", { clear = true }),
	desc = "LspAttach common callback",
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		M.on_attach(client, bufnr)
	end,
})

local function get_lsp_augroup(name, bufnr)
	local group = vim.api.nvim_create_augroup(name, { clear = false })

	vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

	return group
end

-- keymaps
M.on_attach = function(client, bufnr, ...)
	-- completion.on_attach(client, bufnr)
	-- require("lsp_signature").on_attach({
	-- 	bind = true, -- This is mandatory, otherwise border config won't get registered.
	-- 	handler_opts = {
	-- 		border = "single",
	-- 	},
	-- 	hint_prefix = "󰊕 ",
	-- }, bufnr)

	local function buf_set_keymap(mode, lhs, rhs, opts)
		-- vim.api.nvim_buf_set_keymap(bufnr, ...)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	-- Mappings.
	local opts = { silent = true }

	buf_set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

	buf_set_keymap("n", "<F12>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "<S-F12>", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("i", "<F12>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("i", "<S-F12>", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)

	buf_set_keymap("n", "<F5>", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts)

	buf_set_keymap({ "v", "n" }, "<F6>", function()
		vim.lsp.buf.code_action()
	end, opts)

	-- buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "K", function()
		if require("dap").session() ~= nil then
			require("dap.ui.widgets").hover(nil, { border = "rounded" })
		end
		vim.lsp.buf.hover({ border = "rounded" })
	end, opts)
	buf_set_keymap("n", "<C-k>", function()
		vim.lsp.buf.signature_help({ border = "rounded" })
	end, opts)
	-- buf_set_keymap("n", "<leader>k", "<cmd>lua require('custom.lsp_utils').cursor_hold(true)<CR>", opts)

	-- buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "gi", function()
		require("snacks").picker.lsp_implementations({
			layout = "small",
		})
	end, opts)

	-- buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	-- buf_set_keymap("n", "gr", "<cmd>lua require('trouble').toggle('lsp_references')<CR>", opts)
	buf_set_keymap("n", "gr", function()
		require("snacks").picker.lsp_references({
			layout = "small",
		})
	end, opts)

	buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		group = get_lsp_augroup("lsp_formatting", bufnr),
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format({ bufnr = bufnr })
		end,
	})

	local lsp_line_diagnostic_group = get_lsp_augroup("lsp_line_diagnostic", bufnr)
	vim.api.nvim_create_autocmd({ "CursorHold" }, {
		group = lsp_line_diagnostic_group,
		buffer = bufnr,
		callback = function()
			require("custom.lsp_utils").cursor_hold()
		end,
	})
	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		group = lsp_line_diagnostic_group,
		buffer = bufnr,
		callback = function()
			require("custom.lsp_utils").cursor_moved()
		end,
	})

	local has_code_lens = not not client.server_capabilities.codeLensProvider

	if has_code_lens then
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			group = get_lsp_augroup("lsp_codelens", bufnr),
			buffer = bufnr,
			callback = function(event)
				vim.lsp.codelens.refresh({ bufnr = bufnr })
			end,
		})
	end

	vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

	if client:supports_method("textDocument/documentHighlight") then
		local document_highlight_group = get_lsp_augroup("lsp_document_highlight", bufnr)
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = document_highlight_group,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.document_highlight()
			end,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved" }, {
			group = document_highlight_group,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.clear_references()
			end,
		})
	end

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
		vim.lsp.buf.format()
	end, {})
end

return M
