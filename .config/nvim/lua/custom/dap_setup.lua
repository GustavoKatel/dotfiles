local dap = require("dap")
local dap_local_project_config = require("custom.dap_local_project_config")

-- local dapui = require("dapui")
-- dapui.setup()
local dapview = require("dap-view")

require("dap.ext.vscode").json_decode = require("overseer.json").decode
require("dap.ext.vscode").load_launchjs()

local widgets = require("custom.dap_widgets")
widgets.setup()

require("dap-go").setup({
	dap_configurations = {
		{
			type = "go",
			name = "Attach remote",
			mode = "remote",
			request = "attach",
			port = 2345,
		},
	},
})

--dap.set_log_level("TRACE")

dap.listeners.after.initialize.sessions_open = function()
	widgets.sessions.open()
end

dap.listeners.before.attach.ui_config = function()
	dapview.open()
	widgets.open_all()
end
dap.listeners.before.launch.ui_config = function()
	dapview.open()
	widgets.open_all()
end
dap.listeners.before.event_terminated.ui_config = function()
	-- dapview.close()
end
dap.listeners.before.event_exited.ui_config = function()
	-- dapview.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
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
