let g:vimspector_enable_mappings = 'CUSTOM'
let g:vimspector_install_gadgets = [ 'debugpy', 'CodeLLDB' ]

" make breakpoint signs show above other signs
let g:vimspector_sign_priority = {
  \    'vimspectorBP':         998,
  \    'vimspectorBPCond':     998,
  \    'vimspectorBPDisabled': 998,
  \    'vimspectorPC':         999,
  \    'vimspectorPCBP':       999,
  \ }

nmap <C-F8> <Plug>VimspectorToggleBreakpoint
nmap <C-F6> <Plug>VimspectorStepOver
nmap <C-F7> <Plug>VimspectorContinue

nmap <C-F9> <Plug>VimspectorStepInto
nmap <C-F10> <Plug>VimspectorStepOut

nmap <C-F1> :call vimspector#Launch()<CR>
nmap <C-F2> :VimspectorReset<CR>:tabprevious<CR>
