local v = require("utils")

local NotesFolder = vim.fn.expand("~/code_notes")

vim.fn.mkdir(NotesFolder, "p")

local function create_filename(name)
	local filename = NotesFolder .. "/" .. name .. ".md"
	return filename
end

v.cmd["NotesNew"] = function(name)
	local filename = create_filename(name)
	v.cmd.edit(filename)
end

v.cmd["NotesVsNew"] = function(name)
	local filename = create_filename(name)
	v.cmd.vsplit(filename)
end

v.cmd["Notes"] = function()
	require("telescope.builtin").find_files({ search_dirs = { NotesFolder } })
end
