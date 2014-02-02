function AutoCompletar(direcao)
   let posicao = col(".") - 1
   if ! posicao && getline(".")[posicao - 1] !~ '\k'
      return "\<Tab>"
   elseif a:direcao == "avancar" 
      return "\<C-n>"
   else
      return "\<C-p>"
   endif
endfunction

inoremap <C-@> <C-R>=AutoCompletar("avancar")<CR>
inoremap <S-@> <C-R>=AutoCompletar("voltar")<CR>

" Options
set number
set expandtab
set tabstop=4
colorscheme hipster
