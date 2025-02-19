local neotest = require("neotest")

local M = {}

-- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
-- 	group = vim.api.nvim_create_augroup("neotest_custom_utils", { clear = true }),
-- 	callback = function()
-- 		local file_path = vim.api.nvim_buf_get_name(0)
-- 		local row = vim.api.nvim_win_get_cursor(0)[1]
--
-- 		neotest.null_ls_consumer._async_tree_load(file_path, row, function(tree_data)
-- 			-- nothing for now
-- 		end)
-- 	end,
-- })

neotest.setup({
	icons = {
		running = "💈",
	},
	status = {
		virtual_text = false,
		signs = true,
	},
	strategies = {
		integrated = {
			width = 180,
		},
	},
	log_level = vim.log.levels.DEBUG,
	adapters = {
		require("neotest-plenary"),
		require("neotest-golang")({
			testify_enabled = true,
		}),
		require("neotest-jest")({
			jestCommand = "npm run test --",
		}),
		--require("neotest-vim-test")({
		--allow_file_types = { "typescript" },
		--}),
	},
	consumers = {
		overseer = require("neotest.consumers.overseer"),
		null_ls_consumer = function(client)
			return {
				_async_tree_load = function(file_path, row, cb)
					local tree, adapter_id = client:get_nearest(file_path, row, nil)

					print("finished loading tree")
					cb({})
				end,
				get_code_actions = function(file_path, row, cb)
					require("neotest.async").run(function()
						local tree, adapter_id = client:get_nearest(file_path, row, nil)

						if tree == nil or adapter_id == nil then
							cb({})
							return
						end

						-- Use "tree:data().name" to get the test name
						cb({
							{
								title = string.format("Run test: nearest [%s]", adapter_id),
								action = function()
									neotest.run.run({ adapter = adapter_id })
								end,
							},

							{
								title = string.format("Run test: file [%s]", adapter_id),
								action = function()
									neotest.run.run({ file_path, adapter = adapter_id })
								end,
							},

							{
								title = string.format("Run test: suite [%s]", adapter_id),
								action = function()
									neotest.run.run({ adapter = adapter_id, suite = true })
								end,
							},

							{
								title = string.format(
									"Debug test: nearest [%s]",
									-- vim.bo.filetype == "go" and "dap-go" or adapter_id
									adapter_id
								),
								action = function()
									-- if vim.bo.filetype == "go" then
									-- 	require("dap-go").debug_test()
									-- 	return
									-- end
									neotest.run.run({ adapter = adapter_id, strategy = "dap" })
								end,
							},

							{
								title = string.format(
									"Debug test: file [%s]",
									-- vim.bo.filetype == "go" and "dap-go" or adapter_id
									adapter_id
								),
								action = function()
									-- if vim.bo.filetype == "go" then
									-- 	require("dap").run({
									-- 		type = "go",
									-- 		name = "Debug test file",
									-- 		request = "launch",
									-- 		mode = "test",
									-- 		program = "${file}",
									-- 		buildFlags = require("dap-go").test_buildflags,
									-- 	})
									-- 	return
									-- end

									neotest.run.run({ file_path, adapter = adapter_id, strategy = "dap" })
								end,
							},

							{
								title = string.format(
									"Debug test: suite [%s]",
									-- vim.bo.filetype == "go" and "dap-go" or adapter_id
									adapter_id
								),
								action = function()
									-- if vim.bo.filetype == "go" then
									-- 	require("dap").run({
									-- 		type = "go",
									-- 		name = "Debug test (go.mod)",
									-- 		request = "launch",
									-- 		mode = "test",
									-- 		program = "./${relativeFileDirname}",
									-- 		buildFlags = require("dap-go").test_buildflags,
									-- 	})
									-- 	return
									-- end

									neotest.run.run({ adapter = adapter_id, suite = true, strategy = "dap" })
								end,
							},

							{
								title = "Open test output",
								action = function()
									neotest.output.open({ enter = true })
								end,
							},
							{
								title = "Open test output [panel]",
								action = function()
									neotest.output_panel.open()
								end,
							},
						})
					end)
				end,
			}
		end,
	},
})

local null_ls = require("null-ls")

local neotest_code_actions = {
	method = null_ls.methods.CODE_ACTION,
	filetypes = {}, -- all filetypes
	generator = {
		async = true,
		fn = function(params, done)
			neotest.null_ls_consumer.get_code_actions(params.bufname, params.row, done)
		end,
	},
}
-- null_ls.register(neotest_code_actions)
