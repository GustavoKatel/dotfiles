" sets the window/terminal title based on current dir
set title

function! s:update_title()
    " let &titlestring=v:event['cwd']
    
    let titlestring = fnamemodify(getcwd(), ':t')

    if $DEVCONTAINER_PROJECT != ""
        let titlestring = $DEVCONTAINER_PROJECT . " - " . titlestring
    endif

    "echo titlestring

    let &titlestring=titlestring
endfunction

augroup dirchange
    autocmd!
    " autocmd DirChanged * let &titlestring=v:event['cwd']
    autocmd DirChanged * call s:update_title()
augroup END

command! UpdateTitle call s:update_title()
