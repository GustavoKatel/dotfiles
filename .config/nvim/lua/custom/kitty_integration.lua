local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local M = {}

function M.new_tab_from_dev_folder(opts)
	opts = opts or {}

	local folders_to_search = { "~/dev", "~/Development" }

	local find_command = vim.tbl_flatten({ "fd", "--type", "d", "--max-depth", "1", "''", folders_to_search })

	opts.entry_maker = opts.entry_maker
		or function(entry)
			return {
				value = entry,
				display = entry[1],
				ordinal = entry[1],
			}
		end

	pickers
		.new(opts, {
			prompt_title = "New Kitty tab",
			finder = finders.new_oneshot_job(find_command, opts),
			previewer = false,
			sorter = conf.file_sorter(opts),
		})
		:find()
end

return M
