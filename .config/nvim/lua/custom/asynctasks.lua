-- TODO: remove utils support
local v = require("custom.utils")

v.fn["AsyncTasksRunnerFloaterm"] = function(opts)
	v.cmd.FloatermNew(opts.cmd)
end

v.fn["AsyncTasksRunnerHarpoon"] = function(opts)
	require("harpoon.term").sendCommand(1, opts.cmd)
	--require("harpoon.term").gotoTerminal(1)
end

vim.cmd("let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})")
vim.cmd("let g:asyncrun_runner.floaterm = function('AsyncTasksRunnerFloaterm')")
vim.cmd("let g:asyncrun_runner.harpoon = function('AsyncTasksRunnerHarpoon')")
--v.v.g.asynctasks_term_pos = "floaterm"
v.v.g.asynctasks_term_pos = "harpoon"

v.v.g.asynctasks_config_name = ".nvim/tasks.ini"
