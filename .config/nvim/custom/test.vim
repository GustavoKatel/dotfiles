let test#strategy = "floaterm"

nmap <C-F10> :TestNearest<CR>


function! EchoStrategy(cmd)
  echo 'It works! Command for running tests: ' . a:cmd
endfunction

let g:test#custom_strategies = {'echo': function('EchoStrategy')}

let g:test#rust#cargotest#test_patterns = {
        \ 'test': ['\v(#\[%(tokio::|rs)?test)','\v(#\[(.+)?test)'],
        \ 'namespace': ['\vmod (tests?)']
    \ }
