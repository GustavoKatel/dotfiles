local default_opts = {
	filetypes = {
		"http",
	},
}

local M = {
	closing = false,
}

function M.setup(opts)
	opts = opts or {}

	M.opts = vim.tbl_deep_extend("force", {}, default_opts, opts)

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("restnvim_httpls_lsp_attach", { clear = true }),
		pattern = M.opts.filetypes,
		callback = function()
			M.start()
		end,
	})
end

function M.start()
	vim.lsp.start({
		name = "restnvim_httpls",
		cmd = M.client_init,
		root_dir = vim.fn.getcwd(),
	})
end

function M.client_init(dispatchers)
	M.dispatchers = dispatchers

	return M
end

function M.request(method, params, callback, notify_reply_callback)
	if M[method] ~= nil then
		return M[method](method, params, callback, notify_reply_callback), nil
	end

	return false, nil
end

function M.notify(method, params)
	return true
end

function M.is_closing()
	return M.closing
end

function M.terminate()
	if not M.closing then
		M.closing = true
		M.dispatchers.on_exit(0, 0)
	end
end

M["initialize"] = function(method, params, callback)
	callback(nil, {
		capabilities = {
			codeLensProvider = {},
			executeCommandProvider = {
				commands = {
					"restnvim_httpls.run",
					"restnvim_httpls.curl",
				},
			},
		},
	})

	return true
end

M["textDocument/codeLens"] = function(method, params, callback)
	local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
	local source_fname = vim.uri_to_fname(params.textDocument.uri)

	local ft = vim.api.nvim_get_option_value("filetype", {
		buf = bufnr,
	})

	local ok, is_ignored = pcall(vim.api.nvim_buf_get_var, bufnr, "__rest_no_http_file")

	if not ft or (ok and is_ignored) then
		callback(nil, nil)
		return true
	end

	local codelenses = {}

	local query = vim.treesitter.query.get(ft, "requests")
	if not query then
		callback(nil, {})
		return true
	end

	local root = vim.treesitter.get_parser(bufnr, ft):parse(true)[1]:root()

	for id, node, metadata, match in query:iter_captures(root, bufnr) do
		local name = query.captures[id] -- name of the capture in the query
		-- typically useful info about the node:
		local row1, col1, row2, col2 = node:range() -- range of the capture
		local _ = metadata[id]

		if name == "request" then
			table.insert(codelenses, {
				range = {
					start = { line = row1, character = col1 },
					["end"] = { line = row2, character = col2 },
				},
				command = {
					title = "Run",
					command = "restnvim_httpls.run",
					arguments = {},
				},
			})

			table.insert(codelenses, {
				range = {
					start = { line = row1, character = col1 },
					["end"] = { line = row2, character = col2 },
				},
				command = {
					title = "Copy curl",
					command = "restnvim_httpls.curl",
					arguments = {},
				},
			})
		end
	end

	callback(nil, codelenses)

	return true
end

M["workspace/executeCommand"] = function(method, params, callback)
	if params.command == "restnvim_httpls.run" then
		vim.cmd.Rest("run")
	end

	if params.command == "restnvim_httpls.curl" then
		vim.cmd.Rest("curl", "yank")
	end

	callback(nil, nil)

	return true
end

return M
