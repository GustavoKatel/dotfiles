function! db#adapter#redisdocker#input_extension(...) abort
  return 'redisdocker'
endfunction

function! db#adapter#redisdocker#canonicalize(url) abort
  return substitute(a:url, '^redisdocker:/\=/\@!', 'redisdocker:///', '')
endfunction

function! db#adapter#redisdocker#interactive(url) abort
  return ['docker', 'run', '-i', '--rm', '--net=host', 'redis:alpine', 'redis-cli'] + db#url#as_argv(a:url, '-h ', '-p ', '', '', '-a ', '-n ')
endfunction

function! db#adapter#redisdocker#auth_input() abort
  return 'dbsize'
endfunction

function! db#adapter#redisdocker#auth_pattern() abort
  return '(error) ERR operation not permitted'
endfunction
