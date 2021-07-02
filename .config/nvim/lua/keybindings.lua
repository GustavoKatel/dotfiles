local v = require("utils")

-- v.nnoremap({'<silent>', '<CR>'}, v.cmd.nohlsearch)

-- save with ctrl-s/command-s
if v.v.g['gonvim_running'] == 1 then 
    v.nnoremap({"<D-s>"}, ":w<CR>")
    v.inoremap({"<D-s>"}, "<ESC>:w<CR>i")
else 
    v.nnoremap({"<C-s>"}, ":w<CR>")
    v.inoremap({"<C-s>"}, "<ESC>:w<CR>i")
end

-- vertical split with ctrl-\ | command-\
if v.v.g['gonvim_running'] == 1 then 
    v.nnoremap({"<D-\\>"}, ":vsplit<CR>")
else 
    v.nnoremap({"<C-\\>"}, ":vsplit<CR>")
end

-- ctrl-/ to toggle comment, C-_ can also be interpreted as ctrl-/
v.inoremap({"<C-_>"}, "call NERDCommenter('n', 'insert'")
v.inoremap({"<C-/>"}, "<Plug>NERDCommenterInsert")

v.nnoremap({"<C-_>"}, "<Plug>NERDCommenterToggle")
v.nnoremap({"<C-/>"}, "<Plug>NERDCommenterToggle")

v.vnoremap({"<C-_>"}, "<Plug>NERDCommenterToggle<CR>gv")
v.vnoremap({"<C-/>"}, "<Plug>NERDCommenterToggle<CR>gv")
