" use ripgrep as source to fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob "!.git" --iglob "!venv"'

" smaller window - good for ultrawide
let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.6 } }

" Asynctasks fzf integration
function! s:fzf_sink(what)
    let p1 = stridx(a:what, '<')
    if p1 >= 0
        let name = strpart(a:what, 0, p1)
        let name = substitute(name, '^\s*\(.\{-}\)\s*$', '\1', '')
        if name != ''
            exec "AsyncTask ". fnameescape(name)
        endif
    endif
endfunction

function! s:fzf_task()
    let rows = asynctasks#source(&columns * 48 / 100)
    let source = []
    for row in rows
        let name = row[0]
        let source += [name . '  ' . row[1] . '  : ' . row[2]]
    endfor
    let opts = { 'source': source, 'sink': function('s:fzf_sink'),
                \ 'options': '+m --nth 1 --inline-info --tac' }
    call fzf#run(fzf#wrap(opts))
endfunction

command! -nargs=0 AsyncTaskFzf call s:fzf_task()

" key bindings
map <C-b> :Buffers<CR>
"map <C-p> :FZF<CR>
map <C-p> :MultiDirFzf<CR>
map <C-S-P> :Commands<CR>
" Ctrl+Alt+p include ignored files
map <C-M-p> :MultiDirFzf --no-ignore<CR>

" alt+f to search in all files
nnoremap <M-f> :MultiDirRg<CR>
inoremap <M-f> <ESC>:MultiDirRg<CR>
vnoremap <M-f> y:MultiDirRg <C-R>"<CR>

" alt+f9 to open tasks window
nnoremap <M-F9> :AsyncTaskFzf<CR>
