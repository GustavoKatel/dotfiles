local v = require("utils")

-- v.nnoremap({'<silent>', '<CR>'}, v.cmd.nohlsearch)

-- save with ctrl-s/command-s
v.nnoremap({"<D-s>"}, ":w<CR>")
v.inoremap({"<D-s>"}, "<ESC>:w<CR>i")
v.nnoremap({"<C-s>"}, ":w<CR>")
v.inoremap({"<C-s>"}, "<ESC>:w<CR>i")

-- vertical split with ctrl-\ | command-\
v.nnoremap({"<D-\\>"}, ":vsplit<CR>")
v.nnoremap({"<C-\\>"}, ":vsplit<CR>")

-- ctrl/cmd-/ to toggle comment, C-_ can also be interpreted as ctrl-/
for _, code in ipairs({"<C-_>", "<C-/>", "<D-/>"}) do
    v.imap({code}, "<Plug>NERDCommenterInsert")
    v.nmap({code}, "<Plug>NERDCommenterToggle<CR>")
    v.vmap({code}, "<Plug>NERDCommenterToggle<CR>gv")
end

-- Alt-Shift-Left/Right to move to previous next position
v.nnoremap({"<M-S-Right>"}, "<C-I>")
v.nnoremap({"<M-S-Left>"}, "<C-O>")

-- use <TAB> to select the popup menu
v.inoremap({"<expr>", "<Tab>"}, 'pumvisible() ? "\\<C-n>" : "\\<Tab>"')
v.inoremap({"<expr>", "<S-Tab>"}, 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"')

-- ctrl/cmd-d kill buffer without losing split/window
v.nnoremap({"<C-d>"}, ":BD<CR>")
v.nnoremap({"<D-d>"}, ":BD<CR>")

-- toggle workspace
v.nnoremap({"<leader>s"}, v.cmd.ToggleWorkspace)

-- change focus splits using keypad, does not work on every terminal
v.nnoremap({"<silent>", "<D-k6>"}, "<c-w>l")
v.nnoremap({"<silent>", "<D-k4>"}, "<c-w>h")
v.nnoremap({"<silent>", "<D-k8>"}, "<c-w>k")
v.nnoremap({"<silent>", "<D-k2>"}, "<c-w>j")


-- insert mode ctrl/cmd+v paste from clipboard
v.inoremap({"<silent>", "<C-v>"}, '<ESC>"+pa')
v.inoremap({"<silent>", "<D-v>"}, '<ESC>"+pa')
-- visual mode ctrl/cmd+c copy to clipboard
v.vnoremap({"<silent>", "<C-c>"}, '"+y')
v.vnoremap({"<silent>", "<D-c>"}, '"+y')


-- terminal keymaps
-- ctrl-c will close processes in normal mode
v.autocmd("TermOpen", "*", function() v.nnoremap({"<buffer>", "<C-c>"}, "i<C-c>") end)
-- forcily close buffer without closing split BD!
v.autocmd("TermOpen", "*", function() v.nnoremap({"<buffer>", "<C-d>"}, ":BD!<CR>") end)
-- forcily close buffer and split
v.autocmd("TermOpen", "*", function() v.nnoremap({"<buffer>", "<C-q>"}, ":bd!<CR>") end)


-- PageUp PageDown to navigate through buffers
v.nnoremap({"<C-PageUp>"}, v.cmd.bprevious)
v.nnoremap({"<C-PageDown>"}, v.cmd.bnext)

-- ctrl/cmd-a select all in insert and normal modes
for _, code in ipairs({"<C-a>", "<D-a>"}) do
    v.inoremap({code}, "<ESC>ggVG")
    v.nnoremap({code}, "ggVG")
end


-- toggle Undotree with F4
v.nnoremap({"<F4>"}, v.cmd.UndotreeToggle)


-- alt-b to create a new buffer in the current split
v.nnoremap({"<M-b>"}, v.cmd.enew)


-- ctrl/cmd-f search in current buffer
for _, code in ipairs({"<C-f>", "<D-f>"}) do
    v.nnoremap({code}, "/")
end


-- visual mode searches for the selected text
v.vnoremap({"/"}, "y/<C-R>=escape(@\",'/\\')<CR><CR>")
v.vnoremap({"<C-f>"}, "y/<C-R>=escape(@\",'/\\')<CR><CR>")
v.vnoremap({"<D-f>"}, "y/<C-R>=escape(@\",'/\\')<CR><CR>")

-- visual mode replace the currently selected text
v.vnoremap({"<C-h>"}, "y:%s/<C-R>=escape(@\",'/\\')<CR>/")
v.vnoremap({"<D-h>"}, "y:%s/<C-R>=escape(@\",'/\\')<CR>/")

-- ctrl-enter in insert mode to create new line below
v.inoremap({"<C-CR>"}, "<ESC>o")
-- shift-enter in insert mode to create new line above
v.inoremap({"<S-CR>"}, "<ESC>O")

-- remove search highlight on ESC
v.nnoremap({"<ESC>"}, v.cmd.noh)

-- fold keys
v.nnoremap({"<C-[>"}, v.cmd.foldclose)
v.nnoremap({"<D-[>"}, v.cmd.foldclose)
v.nnoremap({"<C-]>"}, v.cmd.foldopen)
v.nnoremap({"<D-]>"}, v.cmd.foldopen)


-- delete current line in insert mode with shift-del
v.inoremap({"<S-Del>"}, "<ESC>ddi")


-- line movement
v.nnoremap({"<M-Down>"}, ":m .+1<CR>==")
v.nnoremap({"<M-Up>"}, ":m .-2<CR>==")
v.inoremap({"<M-Down>"}, "<Esc>:m .+1<CR>==gi")
v.inoremap({"<M-Up>"}, "<Esc>:m .-2<CR>==gi")
v.vnoremap({"<M-Down>"}, ":m '>+1<CR>gv=gv")
v.vnoremap({"<M-Up>"}, ":m '<-2<CR>gv=gv")

-- duplicate line with Ctrl/cmd+Shift+D
v.nnoremap({"<C-S-D>"}, "yyp")
v.nnoremap({"<D-D>"}, "yyp")
v.inoremap({"<C-S-D>"}, "<ESC>yypi")
v.inoremap({"<D-D>"}, "<ESC>yypi")


