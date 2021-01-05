
function! s:global_updater()
    exec "CocUpdateSync"
    " close the last buffer created by Coc
    exec "BD!"
    exec "PlugUpgrade"
    exec "PlugUpdate"
    exec "UpdateRemotePlugins"
    exec "TSUpdate"
    " close the last split created by Plug
    exec "q"
endfunction

command! -nargs=0 UpdateAll call s:global_updater()
