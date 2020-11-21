source $HOME/.config/nvim/custom/pluggins.vim

" [neo]vim specific
source $HOME/.config/nvim/custom/general.vim
source $HOME/.config/nvim/custom/title.vim

" plugins config
source $HOME/.config/nvim/custom/airline.vim
source $HOME/.config/nvim/custom/fern.vim
source $HOME/.config/nvim/custom/coc.vim
source $HOME/.config/nvim/custom/fzf.vim
source $HOME/.config/nvim/custom/floaterm.vim
source $HOME/.config/nvim/custom/asynctasks.vim
source $HOME/.config/nvim/custom/vimspector.vim
source $HOME/.config/nvim/custom/workspace.vim
source $HOME/.config/nvim/custom/easymotion.vim
source $HOME/.config/nvim/custom/test.vim

" personal plugins
source $HOME/.config/nvim/custom/updater.vim
source $HOME/.config/nvim/custom/multi_dir.vim
 
" testing
"source $HOME/.config/nvim/custom/treesitter.vim

lua require("treesitter")
"lua require("lsp_settings")
