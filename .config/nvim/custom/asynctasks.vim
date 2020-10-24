" add floaterm runner to asynctasks
function! s:runner_proc(opts)
    execute 'FloatermNew '..a:opts.cmd
endfunction

let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
let g:asyncrun_runner.floaterm = function('s:runner_proc')
let g:asynctasks_term_pos = "floaterm"
" asynctasks quickfix window auto-open
"let g:asyncrun_open = 6

