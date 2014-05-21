filetype plugin indent on
filetype plugin on

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

" gundo key map
nnoremap <F5> :GundoToggle<CR>

" tag input ( \y ) <- surround plugin
nmap <leader>y ysiw

" auto comment ( \\ ) <- tcomment plugin
nmap <leader><leader> gcc
vmap <leader><leader> gc

" reselect visual block after indent/outdent
noremap < <gv
vnoremap > >gv

" pathogen plugin system
execute pathogen#infect()
execute pathogen#helptags()

" Options
set number
colorscheme deathstar
set laststatus=2

" Special chars
" set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
set list
