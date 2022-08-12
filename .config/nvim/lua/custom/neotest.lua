local neotest = require("neotest")

neotest.setup({
	status = {
		virtual_text = true,
		signs = false,
	},
	strategies = {
		integrated = {
			width = 180,
		},
	},
	adapters = {
		require("neotest-plenary"),
		require("neotest-go"),
		require("neotest-jest")({
			jestCommand = "npm run test --",
		}),
		--require("neotest-vim-test")({
		--allow_file_types = { "typescript" },
		--}),
	},
	consumers = {
		null_ls_consumer = function(client)
			return {
				get_code_actions = function(file_path, row, cb)
					require("neotest.async").run(function()
						local tree, adapter_id = client:get_nearest(file_path, row, nil)

						if tree == nil or adapter_id == nil then
							cb({})
							return
						end

						-- tree:data().name
						cb({
							{
								title = string.format("Run test: nearest [%s]", adapter_id),
								action = function()
									neotest.run.run({ adapter = adapter_id })
								end,
							},

							{
								title = string.format("Run test: suite [%s]", adapter_id),
								action = function()
									neotest.run.run({ adapter = adapter_id, suite = true })
								end,
							},
						})
					end)
				end,
			}
		end,
	},
	icons = {
		running = "💈",
	},
})

local null_ls = require("null-ls")

local neotest_code_actions = {
	method = null_ls.methods.CODE_ACTION,
	filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "go" },
	generator = {
		async = true,
		fn = function(params, done)
			neotest.null_ls_consumer.get_code_actions(params.bufname, params.row, done)
		end,
	},
}
null_ls.register(neotest_code_actions)
