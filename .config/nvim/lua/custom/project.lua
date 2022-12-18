-- Project.nvim

local pasync = require("plenary.async")

local wrap_logger_func = function(banner, level)
	return vim.schedule_wrap(function(msg, ...)
		vim.notify(banner .. string.format(msg, ...), level)
	end)
end

local logger_banner = "[project.nvim]"

local logger = {
	error = wrap_logger_func(logger_banner, vim.log.levels.ERROR),
	warn = wrap_logger_func(logger_banner, vim.log.levels.WARN),
	info = wrap_logger_func(logger_banner, vim.log.levels.INFO),
	debug = wrap_logger_func(logger_banner, vim.log.levels.DEBUG),
	trace = wrap_logger_func(logger_banner, vim.log.levels.TRACE),
}

local M = {
	_opts = {},

	current = {},

	_handlers = {},
}

M.default_opts = {
	local_folder_name = ".nvim",

	auto_load = true,
	auto_create = true,
}

function M.setup(opts)
	M._opts = vim.tbl_extend("force", {}, M.default_opts, opts or {})

	-- set initial project metadata, it's overriden later if local file exists
	M.current = { name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") }

	if M._opts.auto_create then
		if vim.fn.filereadable(vim.fn.expand(M._opts.local_folder_name .. "/project.json")) ~= 1 then
			local init_project_data = vim.json.encode(M.current)
			vim.cmd(string.format([[!mkdir -p .nvim && echo '%s' > .nvim/project.json]], init_project_data))
		end
	end

	if M._opts.auto_load then
		M.setup_auto_load()
	end
end

function M.setup_auto_load()
	local group = vim.api.nvim_create_augroup("project_nvim", { clear = true })

	vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
		group = group,
		desc = "load local project configuration on startup",
		callback = function()
			M.load()
		end,
	})

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = group,
		desc = "reload local project configuration after save",
		pattern = M._opts.local_folder_name .. "project.json",
		callback = function()
			M.load()
		end,
	})
end

function M.get_local_filename()
	return M._opts.local_folder_name .. "/project.json"
end

function M.load()
	pasync.run(function()
		local err, fd = pasync.uv.fs_open(M.get_local_filename(), "r", 438)
		if err then
			logger.error("could not open file: %s", err)
			return nil
		end

		local stat
		err, stat = pasync.uv.fs_fstat(fd)
		assert(not err, err)

		local data
		err, data = pasync.uv.fs_read(fd, stat.size, 0)
		assert(not err, err)

		err = pasync.uv.fs_close(fd)
		assert(not err, err)

		local ok, project = pcall(vim.json.decode, data)
		assert(ok, project)

		M.current = project or {}

		M.dispatch_on_load_event()

		logger.info("'%s/project.json' loaded successfully", M._opts.local_folder_name)
	end)
end

function M.register_handler(event, cb)
	M._handlers[event] = M._handlers[event] or {}

	table.insert(M._handlers[event], cb)
end

function M.dispatch_handlers(event, ...)
	for _, handler in ipairs(M._handlers[event] or {}) do
		handler(...)
	end
end

function M.register_on_load_handler(cb)
	M.register_handler("load", cb)
end

function M.dispatch_on_load_event()
	M.dispatch_handlers("load", M.current)
end

return M
