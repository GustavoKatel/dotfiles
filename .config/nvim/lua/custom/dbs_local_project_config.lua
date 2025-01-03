local M = {}

function M.load(project)
	local project_dbs = project.dbs or {}

	vim.g.dbs = project_dbs

	vim.notify("loaded dbs configuration from project.nvim", vim.log.levels.DEBUG)
end

require("custom.project").register_on_load_handler(function(project)
	M.load(project)
end)

return M
