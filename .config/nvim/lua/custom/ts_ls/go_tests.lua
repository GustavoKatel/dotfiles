local custom_tests_handler = function(match, query, metadata, info)
	local lenses = {}

	local lens = {
		-- title = "Run test: " .. test_name,
		command = {
			title = "",
			command = "ts_ls.custom_tests.run",
			arguments = {
				path = vim.fn.fnamemodify(info.filename, ":p:h"),
				-- test_parent_name = test_parent_name,
				-- test_name = test_name_clean,
			},
		},
	}

	local test_name = ""
	local test_parent_name = ""

	for id, nodes in pairs(match) do
		local name = query.captures[id]

		for _, node in ipairs(nodes) do
			-- `node` was captured by the `name` capture in the match

			local mt = metadata[id] -- Node level metadata

			if name == "test_parent_name" then
				test_parent_name = vim.treesitter.get_node_text(node, info.bufnr, { metadata = mt })
				lens.command.arguments.test_parent_name = test_parent_name
			end

			if name == "test_name" then
				test_name = vim.treesitter.get_node_text(node, info.bufnr, { metadata = mt })

				local test_name_clean = string.gsub(test_name or "", "%s", "_")
				lens.command.arguments.test_name = test_name_clean
				lens.title = "Run test: " .. test_name
			end

			if name == "test_func" then
				local range = vim.treesitter.get_range(node, info.bufnr, mt)
				local row1, col1, row2, col2 = range[1], range[2], range[4], range[5]

				lens.range = {
					start = { line = row1, character = col1 },
					["end"] = { line = row2, character = col2 },
				}
				lens.command.arguments.range = lens.range
			end
		end
	end

	if
		(info.range == nil and lens.range ~= nil and lens.range.start ~= nil and lens.range["end"] ~= nil)
		or (info.range.start.line >= lens.range.start.line and info.range["end"].line <= lens.range["end"].line)
	then
		table.insert(lenses, lens)

		local debug_lens = vim.deepcopy(lens)
		debug_lens.title = "Debug test: " .. test_name
		debug_lens.command.title = ""
		debug_lens.command.command = "ts_ls.custom_tests.debug"
		table.insert(lenses, debug_lens)
	end

	return lenses
end

local function run_test(path, test_parent_name, test_name, range)
	local overseer = require("overseer")

	local test_name_parts = { ".*" }
	if test_parent_name and test_parent_name ~= "" then
		table.insert(test_name_parts, test_parent_name)
	end
	table.insert(test_name_parts, test_name)

	local test_name_clean = table.concat(test_name_parts, "/")

	local args = {
		"test",
		"-count=1",
		"-v",
		"-race",
		vim.fs.joinpath(path, "..."),
		"-run",
		test_name_clean,
	}

	local task = overseer.new_task({
		cmd = { "go" },
		args = args,
		components = {
			{ "custom.task_indicator" },
			"default",
		},
		metadata = { bufnr = vim.api.nvim_get_current_buf(), range = range },
	})
	task:start()
	overseer.run_action(task, "open sticky")
end

local function debug_test(path, test_parent_name, test_name)
	require("dap").run({
		name = "Test: " .. test_parent_name .. "/" .. test_name,
		type = "go",
		request = "launch",
		mode = "test",
		program = path,
		args = {
			"-test.run",
			".*/" .. test_parent_name .. "/" .. test_name,
		},
	})
end

return {
	code_lenses = {
		query = "custom_tests",
		commands = {
			{
				command = "ts_ls.custom_tests.run",
				callback = function(arguments)
					run_test(arguments.path, arguments.test_parent_name, arguments.test_name, arguments.range)
				end,
			},
			{
				command = "ts_ls.custom_tests.debug",
				callback = function(arguments)
					debug_test(arguments.path, arguments.test_parent_name, arguments.test_name)
				end,
			},
		},
		handler = custom_tests_handler,
	},
	code_actions = {
		query = "custom_tests",
		commands = {
			{
				command = "ts_ls.custom_tests.run",
				callback = function(arguments)
					run_test(arguments.path, arguments.test_parent_name, arguments.test_name, arguments.range)
				end,
			},
			{
				command = "ts_ls.custom_tests.debug",
				callback = function(arguments)
					debug_test(arguments.path, arguments.test_parent_name, arguments.test_name)
				end,
			},
		},
		handler = custom_tests_handler,
	},
}
