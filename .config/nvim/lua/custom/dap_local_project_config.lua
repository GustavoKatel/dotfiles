local dap = require("dap")

local M = {
	global_config = nil,
}

function M.load(project)
	if not M.global_config then
		M.global_config = vim.deepcopy(dap.configurations)
	end

	dap.configurations = vim.deepcopy(M.global_config)

	local project_dap = project.dap or {}

	for lang, lang_configs in pairs(project_dap.configurations or {}) do
		local existing_configs = dap.configurations[lang] or {}
		dap.configurations[lang] = existing_configs

		for _, cc in ipairs(lang_configs) do
			cc.name = "[local] " .. cc.name
			table.insert(existing_configs, cc)
		end
	end

	print("loaded dap configuration from project.nvim")
end

require("custom.project").register_on_load_handler(function(project)
	M.load(project)
end)

return M
