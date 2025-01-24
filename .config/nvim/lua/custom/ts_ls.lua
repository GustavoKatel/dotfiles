---@class LineColumn
---@field line number
---@field character number

---@class Command
---@field title string
---@field command string
---@field arguments table

---@class Range
---@field start LineColumn
---@field end LineColumn

---@class CodeLens
---@field range Range
---@field command Command

---@enum CodeActionKind
local CodeActionKind = {
	Empty = "",
	QuickFix = "quickfix",
	Refactor = "refactor",
	RefactorExtract = "refactor.extract",
	RefactorInline = "refactor.inline",
	RefactorRewrite = "refactor.rewrite",
	Source = "source",
	SourceOrganizeImports = "source.organizeImports",
	SourceFixAll = "source.fixAll",
}

---@class CodeAction
---@field title string
---@field command Command
---@field kind CodeActionKind

---@class HandlerNodeInfo
---@field filename string
---@field bufnr number
---@field ft string

---@alias CodeLensProviderHandler fun(match: TSQueryMatch, query: vim.treesitter.Query, metadata: vim.treesitter.query.TSMetadata, info: HandlerNodeInfo): CodeLens[]
---@alias CodeActionProviderHandler fun(match: TSQueryMatch, query: vim.treesitter.Query, metadata: vim.treesitter.query.TSMetadata, info: HandlerNodeInfo): CodeAction[]

---@alias CommandHandlerCallback fun(arguments: table): any

---@class CommandHandler
---@field command string
---@field callback CommandHandlerCallback

---@class CodeLensProvider
---@field query string
---@field handler CodeLensProviderHandler
---@field commands CommandHandler[]

---@class CodeActionProvider
---@field query string
---@field handler CodeActionProviderHandler
---@field commands CommandHandler[]

---@class Options
---@field code_actions CodeActionProvider[]
---@field code_lenses CodeLensProvider[]

---@class OptionsSetup
---@field code_actions CodeActionProvider[]?
---@field code_lenses CodeLensProvider[]?

---@type Options
local default_opts = {
	---@type CodeActionProvider[]
	code_actions = {},
	---@type CodeLensProvider[]
	code_lenses = {},

	---@type string | string[]
	languages = "*",
}

local M = {
	closing = false,

	lsp_handlers = {},

	---@type Options
	opts = vim.deepcopy(default_opts),

	command_handlers = {},
}

---@param opts OptionsSetup?
function M.setup(opts)
	opts = opts or {}

	M.opts = vim.tbl_deep_extend("force", {}, default_opts, opts)

	for _, code_lens in ipairs(M.opts.code_lenses) do
		for _, command in ipairs(code_lens.commands) do
			M.command_handlers[command.command] = command.callback
		end
	end

	for _, code_action in ipairs(M.opts.code_actions) do
		for _, command in ipairs(code_action.commands) do
			M.command_handlers[command.command] = command.callback
		end
	end

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("treesitter_ls_injector_lsp_attach", { clear = true }),
		pattern = M.opts.languages,
		callback = function()
			M.start()
		end,
	})
end

function TSLSStart()
	M.start()
end

function M.start()
	vim.lsp.start({
		name = "treesitter_ls_injector",
		cmd = M.client_init,
		root_dir = vim.fn.getcwd(),
	})
end

function M.client_init(dispatchers)
	M.dispatchers = dispatchers

	return M
end

function M.request(method, params, callback, notify_reply_callback)
	if M.lsp_handlers[method] ~= nil then
		return M.lsp_handlers[method](method, params, callback, notify_reply_callback), nil
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

M.lsp_handlers["initialize"] = function(method, params, callback)
	local command_names = vim.tbl_keys(M.command_handlers)

	callback(nil, {
		capabilities = {
			codeLensProvider = {},
			codeActionProvider = {},
			executeCommandProvider = {
				commands = command_names,
			},
		},
	})

	return true
end

---@param bufnr number
---@param lang string
---@param query_name string
---@param filename string
---@param range Range?
---@param handler CodeLensProviderHandler|CodeActionProviderHandler
---@return (CodeLens | CodeAction)[]
function M.fetch_ts_handler(bufnr, lang, query_name, filename, range, handler)
	local query = vim.treesitter.query.get(lang, query_name)
	if not query then
		return {}
	end

	local root = vim.treesitter.get_parser(bufnr, lang):parse(true)[1]:root()

	local results = {}

	local start_row = 0
	local end_row = -1

	if range then
		start_row = range.start.line
		end_row = range["end"].line + 1
	end

	for pattern, match, metadata in query:iter_matches(root, bufnr, start_row, end_row, { all = true }) do
		for _, result in ipairs(handler(match, query, metadata, { filename = filename, bufnr = bufnr, ft = lang })) do
			table.insert(results, result)
		end
	end

	return results
end

M.lsp_handlers["textDocument/codeLens"] = function(method, params, callback)
	local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
	local source_fname = vim.uri_to_fname(params.textDocument.uri)

	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

	if not ft then
		callback(nil, nil)
		return true
	end

	local codelenses = {}

	for _, provider in ipairs(M.opts.code_lenses) do
		local lenses = M.fetch_ts_handler(bufnr, ft, provider.query, source_fname, nil, provider.handler)

		for _, lens in ipairs(lenses) do
			table.insert(codelenses, lens)
		end
	end

	callback(nil, codelenses)

	return true
end

M.lsp_handlers["textDocument/codeAction"] = function(method, params, callback)
	local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
	local source_fname = vim.uri_to_fname(params.textDocument.uri)

	local range = params.range

	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

	if not ft then
		callback(nil, nil)
		return true
	end

	local codeactions = {}

	for _, provider in ipairs(M.opts.code_actions) do
		local actions = M.fetch_ts_handler(bufnr, ft, provider.query, source_fname, range, provider.handler)

		for _, action in ipairs(actions) do
			table.insert(codeactions, action)
		end
	end

	callback(nil, codeactions)

	return true
end

M.lsp_handlers["workspace/executeCommand"] = function(method, params, callback)
	local command = M.command_handlers[params.command]
	if command then
		command(params.arguments)
	end

	callback(nil, nil)

	return true
end

return M
