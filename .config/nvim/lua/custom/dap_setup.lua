local user_profile = require("custom/uprofile")
--local dap_install = require("dap-install")
local dap = require("dap")
local dap_local_project_config = require("custom/dap_local_project_config")

require("dapui").setup()

--dap_install.setup({ installation_path = vim.fn.stdpath("data") .. "/dapinstall/" })

user_profile.with_profile_fn("personal", function()
	--dap_install.config("go", {})
end)

dap.set_log_level("TRACE")

--dap_install.config("jsnode", {
--configurations = {
--{
--name = "${file}",
--type = "node2",
--request = "launch",
--program = "${workspaceFolder}/${file}",
--cwd = vim.fn.getcwd(),
--sourceMaps = true,
--protocol = "inspector",
--console = "integratedTerminal",
--},
--},
--})

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

dap_local_project_config.load()
