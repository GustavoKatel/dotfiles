local telescope = require("telescope")

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local workflows = function(opts)
	opts = opts or {}

	pickers
		.new(opts, {
			prompt_title = "tasks: all",
			finder = generate_new_finder(opts),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()

					local entry = selection.value

					tasks.run(entry.spec_name, nil, entry.source_name)
				end)
				return true
			end,
		})
		:find()
end

return telescope.register_extension({
	exports = {
		workflows = workflows,
	},
})
