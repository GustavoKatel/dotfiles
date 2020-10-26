let g:vimspector_enable_mappings = 'CUSTOM'
let g:vimspector_install_gadgets = [ 'debugpy', 'CodeLLDB' ]


nmap <C-F8> <Plug>VimspectorToggleBreakpoint
nmap <C-F6> <Plug>VimspectorStepOver
nmap <C-F7> <Plug>VimspectorContinue

nmap <C-F9> <Plug>VimspectorStepInto
nmap <C-F10> <Plug>VimspectorStepOut

