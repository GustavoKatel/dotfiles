local v = require("utils")

v.fn["AsyncTasksRunnerFloaterm"] = function(opts)
    v.cmd.FloatermNew(opts.cmd)
end

vim.cmd("let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})")
vim.cmd("let g:asyncrun_runner.floaterm = function('AsyncTasksRunnerFloaterm')")
v.v.g.asynctasks_term_pos = "floaterm"

v.v.g.asynctasks_config_name = ".nvim/tasks.ini"
