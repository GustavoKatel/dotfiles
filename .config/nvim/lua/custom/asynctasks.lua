vim.api.nvim_create_user_command("AsyncTasksRunnerFloaterm", function(opts)
	vim.cmd("FloatermNew " .. opts.cmd)
end, {})

vim.api.nvim_create_user_command("AsyncTasksRunnerHarpoon", function(opts)
	require("harpoon.term").sendCommand(1, opts.cmd)
	--require("harpoon.term").gotoTerminal(1)
end, {})

vim.cmd("let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})")
vim.cmd("let g:asyncrun_runner.floaterm = function('AsyncTasksRunnerFloaterm')")
vim.cmd("let g:asyncrun_runner.harpoon = function('AsyncTasksRunnerHarpoon')")
--v.v.g.asynctasks_term_pos = "floaterm"
vim.g.asynctasks_term_pos = "harpoon"

vim.g.asynctasks_config_name = ".nvim/tasks.ini"
