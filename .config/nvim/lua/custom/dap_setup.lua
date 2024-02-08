local dap = require("dap")
local dap_local_project_config = require("custom.dap_local_project_config")

require("dapui").setup()

--dap.set_log_level("TRACE")

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

dap.configurations.go = {
	{
		type = "go",
		name = "Debug",
		request = "launch",
		program = "${file}",
	},
}

dap.adapters.node2 = {
	type = "executable",
	command = "node-debug2-adapter", -- installed via Mason
	args = {},
}

dap.adapters.node = dap.adapters.node2

-- NOTE: this is now part of go.nvim
-- dap.adapters.go = function(callback, config)
-- 	local stdout = vim.loop.new_pipe(false)
-- 	local handle
-- 	local pid_or_err
-- 	local host = config.host or "127.0.0.1"
-- 	local port = config.port or "38697"
-- 	local addr = string.format("%s:%s", host, port)
-- 	local opts = {
-- 		stdio = { nil, stdout },
-- 		args = { "dap", "-l", addr },
-- 		detached = true,
-- 	}
-- 	handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
-- 		stdout:close()
-- 		handle:close()
-- 		if code ~= 0 then
-- 			print("dlv exited with code", code)
-- 		end
-- 	end)
-- 	assert(handle, "Error running dlv: " .. tostring(pid_or_err))
-- 	stdout:read_start(function(err, chunk)
-- 		assert(not err, err)
-- 		if chunk then
-- 			vim.schedule(function()
-- 				require("dap.repl").append(chunk)
-- 			end)
-- 		end
-- 	end)
-- 	-- Wait for delve to start
-- 	vim.defer_fn(function()
-- 		callback({ type = "server", host = "127.0.0.1", port = port })
-- 	end, 100)
-- end
