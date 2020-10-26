let g:workspace_session_directory = $HOME . '/.config/nvim/sessions/'

if $DEVCONTAINER_PROJECT != ""
    let g:workspace_session_directory = $HOME . '/.config/nvim/sessions/devcontainers_' . $DEVCONTAINER_PROJECT . '/'
endif


let g:workspace_persist_undo_history = 0  " enabled = 1 (default), disabled = 0
" ignore gitcommit and floaterm file types in vim-workspace
"let g:workspace_autosave_ignore = ["gitcommit", "floaterm"]
" do not fu*** auto-save 😡
let g:workspace_autosave = 0

