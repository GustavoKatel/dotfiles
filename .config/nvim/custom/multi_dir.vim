
" copied from https://github.com/junegunn/fzf.vim/blob/master/plugin/fzf.vim
function! s:p(...)
  let preview_args = get(g:, 'fzf_preview_window', ['right', 'ctrl-/'])
  if empty(preview_args)
    return { 'options': ['--preview-window', 'hidden'] }
  endif

  " For backward-compatiblity
  if type(preview_args) == type('')
    let preview_args = [preview_args]
  endif
  return call('fzf#vim#with_preview', extend(copy(a:000), preview_args))
endfunction


function! s:multi_dir_add(...)
    for arg in a:000
        call add(g:multi_dir_dirs, arg)
    endfor
endfunction


function! s:multi_dir_list()
    let dirs = copy(g:multi_dir_dirs)

    call add(dirs, getcwd())

    return dirs
endfunction


function! s:multi_dir_start()
    let g:multi_dir_dirs = []
endfunction


function! s:multi_dir_clear()
    call s:multi_dir_start()
endfunction


function! s:multi_dir_remove(index)
    call remove(g:multi_dir_dirs, a:index)
endfunction


function! s:multi_dir_fzf_edit(...)
    let dirs = join(s:multi_dir_list(), ' ')
    let args = join(a:000, ' ')

    call fzf#run(fzf#wrap({'source': 'rg --files --hidden --iglob "!.git" --iglob "!venv" '.dirs.' '.args.' | xargs realpath --relative-to="$PWD"',
             \ 'sink':  'edit'}))
endfunction


function! s:multi_dir_fzf_rg(...)
    let dirs = join(s:multi_dir_list(), ' ')
    let args = join(a:000, ' ')

    " the reason we call this here and not simply :Rg is bc the later
    " shellescape every arg, we dont want paths to be escaped
    call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case  -- ".shellescape(args)." ".dirs, 1, s:p(), 0)
endfunction

function! s:save_to_session()
    let l:lines = []

        for dir in g:multi_dir_dirs
        call add(l:lines, printf("MultiDirAdd %s", dir))
    endfor

    call g:WorkspaceSessionAddLine(l:lines)
endfunction

augroup MultiDir
    autocmd VimEnter * call s:multi_dir_start()
    autocmd User WorkspacePostSave call s:save_to_session()
augroup end


command! -nargs=* -complete=file MultiDirAdd call s:multi_dir_add(<f-args>)
command! -nargs=0 MultiDirClear call s:multi_dir_clear()
command! -nargs=1 MultiDirRemove call s:multi_dir_remove(<f-args>)
command! -nargs=* MultiDirFzf call s:multi_dir_fzf_edit(<f-args>)
command! -nargs=* MultiDirRg call s:multi_dir_fzf_rg(<f-args>)
