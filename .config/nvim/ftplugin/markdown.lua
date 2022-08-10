-- treesitter testing
local ts_locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")

vim.treesitter.set_query(
	"markdown",
	"markdown_get_checkboxes",
	[[ 
    (list_item) @list_item
   ]]
)

local function iter_children(node)
	for c in node:iter_children() do
		print(c:type())
		iter_children(c)
	end
end

function TSToggleCheckBox()
	local cursor_node = ts_utils.get_node_at_cursor()

	print(cursor_node:type())
	print(cursor_node:parent())

	local scope = ts_locals.get_scope_tree(cursor_node, 0)

	print("children")

	local query = vim.treesitter.get_query("markdown", "markdown_get_checkboxes")

	for _, v in ipairs(scope) do
		print(v:type())
		iter_children(v)
		--for _, node in query:iter_captures(v, 0) do
		--print(node:type())
		--end
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
