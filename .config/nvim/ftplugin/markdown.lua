-- treesitter testing

vim.treesitter.query.set(
	"markdown",
	"markdown_get_checkboxes",
	[[ 
[ 
  ( task_list_marker_checked )
  ( task_list_marker_unchecked )
] @task_list_marker
   ]]
)

vim.treesitter.query.set(
	"markdown",
	"markdown_get_checkboxes",
	[[ 
(list_item
[ 
  ( task_list_marker_checked )
  ( task_list_marker_unchecked )
] @task_list_marker
( paragraph (_) @i)
) 
   ]]
)

local node_replacements = {
	["task_list_marker_checked"] = "[ ]",
	["task_list_marker_unchecked"] = "[x]",
}

local default_replacement = "[ ]"

local function create_change(node, bufnr)
	local range = { node:range() }

	local lines = vim.api.nvim_buf_get_lines(bufnr, range[1], range[3] + 1, false)

	local text = lines[1]

	local text_start = text:sub(1, range[2])
	local text_end = text:sub(range[4] + 1)

	return {
		row_start = range[1],
		row_end = range[3] + 1,
		text = text_start .. (node_replacements[node:type()] or default_replacement) .. text_end,
	}
end

function TSToggleCheckBox()
	local cursor_node = vim.treesitter.get_node()

	local query = vim.treesitter.get_query("markdown", "markdown_get_checkboxes")

	local changes = {}

	for _, node in query:iter_captures(cursor_node, 0) do
		print(node:type())

		local change = create_change(node, 0)
		table.insert(changes, change)
	end

	for _, change in ipairs(changes) do
		vim.api.nvim_buf_set_lines(0, change.row_start, change.row_end, false, { change.text })
	end
end
--

local function toggle_checkbox_line(line)
	if not line then
		return line
	end

	-- check no match and insert [] at the beginning
	local _, _, after = line:find("^%s*-%s*([^%[]*)")
	if after and after ~= "" then
		return string.format("- [ ] %s", after)
	end

	-- replace the first occurrence of [] or [x] (white space between [] is ignored)
	return line:gsub("%[([%sxX]*)%]", function(match)
		if match:find("%s*[xX]%s*") then
			return "[ ]"
		end
		return "[x]"
	end, 1)
end

local function toggle_checkbox(line1, line2)
	local lines = vim.fn.getline(line1, line2)

	lines = vim.tbl_map(function(line)
		return toggle_checkbox_line(line)
	end, lines)

	vim.fn.setline(line1, lines)
end

vim.api.nvim_buf_create_user_command(0, "MarkdownToggleCheckbox", function(opts)
	toggle_checkbox(opts.line1, opts.line2)
end, { desc = "toggle markdown checkboxes", range = true })

vim.keymap.set({ "n", "v" }, "<Space>", function()
	local mode = vim.fn.mode()

	local line1
	local line2

	if mode == "n" then
		line1 = vim.fn.getpos(".")[2]
		line2 = line1
	else
		line1 = vim.fn.getpos("'<")[2]
		line2 = vim.fn.getpos("'>")[2]
	end

	toggle_checkbox(line1, line2)
end, { buffer = 0 })

-- - [] abc
-- - [] abc
-- - [] abc
-- - [] abc
