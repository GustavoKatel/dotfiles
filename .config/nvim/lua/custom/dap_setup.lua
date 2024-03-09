local dap = require("dap")
local dap_local_project_config = require("custom.dap_local_project_config")

local dapui = require("dapui")
dapui.setup()

require("dap.ext.vscode").json_decode = require("overseer.json").decode
require("dap.ext.vscode").load_launchjs()

require("dap-go").setup()

--dap.set_log_level("TRACE")

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
	vim.cmd("SidebarNvimClose")
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
	vim.cmd("SidebarNvimClose")
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "", linehl = "", numhl = "" })

-- CONFIGURATIONS
dap.configurations.typescript = {
	{
		name = "npm start",
		type = "node2",
		request = "launch",
		runtimeExecutable = "npm",
		runtimeArgs = { "run-script", "start" },
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
		outFiles = { "${workspaceRoot}/dist/**/*.js" },
	},
	{
		name = "${file}",
		type = "node2",
		request = "launch",
		program = "${workspaceFolder}/${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
		outFiles = { "${workspaceRoot}/dist/**/*.js" },
	},
	{
		name = "jest",
		type = "node2",
		request = "launch",
		cwd = vim.fn.getcwd(),
		runtimeArgs = {
			"--inspect-brk",
			"${workspaceFolder}/node_modules/.bin/jest",
			"--no-coverage",
			"--",
			"${workspaceFolder}/${file}",
		},
		sourceMaps = true,
		protocol = "inspector",
		skipFiles = { "<node_internals>/**/*.js" },
		console = "integratedTerminal",
		port = 9229,
		outFiles = { "${workspaceRoot}/dist/**/*.js" },
	},
}

dap.adapters.node2 = {
	type = "executable",
	command = "node-debug2-adapter", -- installed via Mason
	args = {},
}

dap.adapters.node = dap.adapters.node2
