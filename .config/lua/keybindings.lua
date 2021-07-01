local v = require("utils")

-- v.nnoremap({'<silent>', '<CR>'}, v.cmd.nohlsearch)

-- save with ctrl-s/command-s
v.nnoremap({"<D-s>"}, ":w<CR>")

