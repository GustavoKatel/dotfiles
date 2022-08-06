local pasync = require("plenary.async")
local utils = require("custom.utils")
local dap = require("dap")

local M = {
	global_config = nil,
}

function M.load()
	if not M.global_config then
		M.global_config = vim.deepcopy(dap.configurations)
	end

	pasync.run(function()
		local config_data = utils.async_read_file(vim.loop.cwd() .. "/.nvim/dap.json")
		if config_data == nil then
			return
		end

		vim.schedule(function()
			vim.notify("using local dap config", vim.log.levels.DEBUG)
		end)

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

		dap.configurations = vim.deepcopy(M.global_config)

		for lang, lang_configs in pairs(config.configurations or {}) do
			local existing_configs = dap.configurations[lang] or {}
			dap.configurations[lang] = existing_configs

			for _, cc in ipairs(lang_configs) do
				cc.name = "[local] " .. cc.name
				table.insert(existing_configs, cc)
			end
		end

		print("loaded dap configuration from '.nvim/dap.json'")
	end, function() end)
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("dap_local_project_config_autocmds", { clear = true }),
	desc = "reload dap custom config",
	pattern = ".nvim/dap.json",
	callback = function()
		M.load()
	end,
})

return M
