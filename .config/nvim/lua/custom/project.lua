-- Project.nvim

local pasync = require("plenary.async")

local wrap_logger_func = function(banner, level)
	return vim.schedule_wrap(function(msg, ...)
		vim.notify(banner .. string.format(msg, ...), level)
	end)
end

local logger_banner = "[project.nvim]"

local log_level_map = {
	error = vim.log.levels.ERROR,
	warn = vim.log.levels.WARN,
	info = vim.log.levels.INFO,
	debug = vim.log.levels.DEBUG,
	trace = vim.log.levels.TRACE,
}

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
	auto_create = false,

	logger_level = vim.log.levels.WARN,
}

local function get_default_config()
	return { name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") }
end

function M.setup(opts)
	M._opts = vim.tbl_extend("force", {}, M.default_opts, opts or {})

	M.setup_logger()

	-- set initial project metadata, it's overriden later if local file exists
	M.current = get_default_config()

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

function M.setup_logger()
	for log_fn_name, level_value in pairs(log_level_map) do
		if level_value < M._opts.logger_level then
			logger[log_fn_name] = function() end
		end
	end
end

function M.get_all_project_files()
	local local_files = vim.fs.find(M._opts.local_folder_name, { type = "directory" })
	local files = vim.fs.find(M._opts.local_folder_name, { type = "directory", limit = math.huge, upward = true })
	local all_files = vim.tbl_extend("force", local_files, files)

	all_files = vim.tbl_map(function(file_path)
		return M.get_local_filename(file_path)
	end, all_files)

	return all_files
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

	local project_files = M.get_all_project_files()
	if #project_files > 0 then
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			group = group,
			desc = "reload local project configuration after save",
			pattern = project_files,
			callback = function()
				M.load()
			end,
		})
	end
end

function M.get_local_filename(folder_name)
	return folder_name .. "/project.json"
end

function M.load()
	pasync.run(function()
		local all_files = M.get_all_project_files()

		local current_config = get_default_config()

		for i = 1, #all_files do
			local current_file = all_files[#all_files + 1 - i]

			local err, fd = pasync.uv.fs_open(current_file, "r", 438)
			if not err then
				local stat
				err, stat = pasync.uv.fs_fstat(fd)
				assert(not err, err)

				local data
				err, data = pasync.uv.fs_read(fd, stat.size, 0)
				assert(not err, err)

				err = pasync.uv.fs_close(fd)
				assert(not err, err)

				local ok, project = pcall(vim.json.decode, data)
				assert(
					ok,
					"failed to parse json from file: "
						.. current_file
						.. "/project.json ERROR: "
						.. (type(project) == "table" and vim.inspect(project) or project)
				)

				current_config = vim.tbl_extend("force", current_config, project)
			end
		end

		M.current = current_config

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
