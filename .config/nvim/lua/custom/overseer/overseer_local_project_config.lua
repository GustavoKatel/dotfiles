local overseer = require("overseer")

local M = {
	current_parser = nil
}

require("custom.project").register_on_load_handler(function(project)
	M.current_parser = nil

	if not project.tasks then
		return
	end

	if project.tasks.parser then
		M.current_parser = { parser = require(project.tasks.parser) }
	end
end)

overseer.add_template_hook({}, function(task_defn, util)
	if M.current_parser == nil then
		return
	end

	local component = vim.tbl_deep_extend("force", {"on_output_parse"}, M.current_parser)
	util.add_component(task_defn, component)
end)
