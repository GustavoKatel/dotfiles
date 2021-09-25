local pasync = require("plenary.async")
local dap = require("dap")

local M = {}

local read_config_file = function(path)
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

function M.load()
	pasync.run(function()
		local config_data = read_config_file(vim.loop.cwd() .. "/.nvim/dap.json")
		if config_data == nil then
			print("no local dap config")
			return
		end

		-- this is not really necessary, I just wanted to try :p
		local sender, receiver = pasync.control.channel.oneshot()

		vim.schedule(function()
			local ret, config = pcall(vim.fn.json_decode, config_data)
			sender(ret, config)
		end)

		local ret, config = receiver()
		if not ret then
			print("error loading local dap config")
			return
		end

		for lang, lang_configs in pairs(config.configurations or {}) do
			local existing_configs = dap.configurations[lang] or {}
			dap.configurations[lang] = existing_configs

			for _, cc in ipairs(lang_configs) do
				cc.name = "[local] " .. cc.name
				table.insert(existing_configs, cc)
			end
		end
	end, function() end)
end

return M
