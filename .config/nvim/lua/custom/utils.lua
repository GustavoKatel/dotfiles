local pasync = require("plenary.async")

local M = {}

-- Some util functions
math.randomseed(os.time())

M.create_autocommands = function(opts)
	opts = vim.tbl_deep_extend("force", { buffer = nil, group = { clear = true, name = nil }, cmds = {} }, opts)

	if opts.group.name == nil then
		vim.notify(
			"utils.create_autocommands: group name '{group = { name = <string> }}' must not be nil",
			vim.log.levels.ERROR
		)
		return
	end

	local group_opts = opts.group

	local cmds = opts.cmds

	local clear_global = group_opts.clear
	local clear_buffer = false

	if opts.buffer ~= nil and clear_global then
		clear_global = false
		clear_buffer = true
	end

	vim.api.nvim_create_augroup(group_opts.name, { clear = clear_global })

	if clear_buffer then
		vim.api.nvim_clear_autocmds({ group = group_opts.name, buffer = opts.buffer })
	end

	for _, cmd_def in ipairs(cmds) do
		vim.api.nvim_create_autocmd(
			cmd_def.events,
			vim.tbl_deep_extend("force", {
				group = group_opts.name,
				buffer = cmd_def.buffer or opts.buffer,
			}, cmd_def.def)
		)
	end
end

M.async_read_file = function(path)
	local err, fd = pasync.uv.fs_open(path, "r", 438)
	if err then
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

	return data
end

return M
