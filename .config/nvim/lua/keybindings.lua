local v = require("utils")

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

-- use <TAB>/arrow keys to select the popup menu
v.inoremap({"<expr>", "<Tab>"}, 'pumvisible() ? "\\<C-n>" : "\\<Tab>"')
v.inoremap({"<expr>", "<Down>"}, 'pumvisible() ? "\\<C-n>" : "\\<Down>"')
v.inoremap({"<expr>", "<S-Tab>"}, 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"')
v.inoremap({"<expr>", "<Up>"}, 'pumvisible() ? "\\<C-p>" : "\\<Up>"')

-- ctrl/cmd-d kill buffer without losing split/window
v.nnoremap({"<C-d>"}, ":BD<CR>")
v.nnoremap({"<D-d>"}, ":BD<CR>")

-- ctrl/cmd-q kill the current split/window
v.nnoremap({"<C-q>"}, ":q<CR>")
v.nnoremap({"<D-q>"}, ":q<CR>")

-- toggle workspace
v.nnoremap({"<leader>s"}, v.cmd.ToggleWorkspace)

-- change focus splits
v.nnoremap({"<silent>", "<D-Right>"}, "<c-w>l")
v.nnoremap({"<silent>", "<D-left>"}, "<c-w>h")
v.nnoremap({"<silent>", "<D-Up>"}, "<c-w>k")
v.nnoremap({"<silent>", "<D-Down>"}, "<c-w>j")

for i = 1,9,1 do
    v.nnoremap({"<silent>", "<D-k"..i..">"}, ":"..i.."wincmd w<CR>")
    v.tnoremap({"<silent>", "<D-k"..i..">"}, "<C-\\><C-N>:"..i.."wincmd w<CR>")
end



-- insert mode ctrl/cmd+v paste from clipboard
for _, code in ipairs({"<C-v>", "<D-v>"}) do
    v.inoremap({"<silent>", code}, '<ESC>"+pa')
    v.tnoremap({"<silent>", code}, '<C-\\><C-N>"+pa')
end
-- same as above, but maps ctrl+shift+v instead of ctrl+v. still uses cmd-v
v.cnoremap({"<C-S-V>", "<D-v>"}, '<C-r>+')

-- visual mode ctrl/cmd+c copy to clipboard
v.vnoremap({"<silent>", "<C-c>"}, '"+y')
v.vnoremap({"<silent>", "<D-c>"}, '"+y')


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
if v.fn.has('macunix') then
    v.nnoremap({"<D-[>"}, v.cmd.foldclose)
    v.nnoremap({"<D-]>"}, v.cmd.foldopen)
else
    v.nnoremap({"<C-[>"}, v.cmd.foldclose)
    v.nnoremap({"<C-]>"}, v.cmd.foldopen)
end

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


-- easymotion/hop.nvim
--v.nmap("f", "<Plug>(easymotion-overwin-f2)")
v.nnoremap("f", function() print("enter 2 char pattern") require('hop').hint_char2() end)
v.nnoremap("<leader>w", require('nvim-window').pick)


-- floaterm keybindings
for _, code in ipairs({"<A-F12>", "<M-F12>"}) do
    v.nnoremap({code}, v.cmd.FloatermToggle)
    v.inoremap({code}, v.cmd.FloatermToggle)
    v.tnoremap({code}, "<C-\\><C-N>:FloatermToggle<CR>")
end


-- terminal keymaps
-- exit terminal mode with <ESC>
v.tnoremap({"<ESC>"}, "<C-\\><C-N>")

-- page up/down to move between terms
v.tnoremap({"<C-PageDown>"}, "<C-\\><C-N>:FloatermNext<CR>")
v.tnoremap({"<C-PageUp>"}, "<C-\\><C-N>:FloatermPrev<CR>")

-- alt-n to create a new term
v.tnoremap({"<M-n>"}, "<C-\\><C-N>:FloatermNew<CR>")

-- ctrl-q to kill current term
v.tnoremap({"<C-q>"}, "<C-\\><C-N>:FloatermKill<CR>")

-- alt-t to open ranger in a float terminal
v.nnoremap({"<A-t>"}, v.cmd.Ranger)

-- ctrl-c will close processes in normal mode
v.autocmd("TermOpen", "*", function() v.nnoremap({"<buffer>", "<C-c>"}, "i<C-c>") end)
-- forcily close buffer without closing split BD!
v.autocmd("TermOpen", "*", function() v.nnoremap({"<buffer>", "<C-d>"}, ":BD!<CR>") end)
-- forcily close buffer and split
v.autocmd("TermOpen", "*", function() v.nnoremap({"<buffer>", "<C-q>"}, ":bd!<CR>") end)


-- telescope files
local function telescope_files(with_gitignored)
    local telescope = require("telescope.builtin")

    local cmd = {"rg", "--files", "--hidden"}

    if with_gitignored then
        table.insert(cmd, "--no-ignore")
    end

    local cmd_args = {
        "-g", "!node_modules/**/*",
        "-g", "!venv/**/*",
        "-g", "!.git/**/*"
    }

    for _, arg in pairs(cmd_args) do
        table.insert(cmd, arg)
    end

    telescope.find_files({
        previewer = false,
        find_command = cmd
    })
end

for _, code in ipairs({"<C-p>", "<D-p>"}) do
    v.nnoremap({code}, function() telescope_files(false) end)
end

-- telescope files, but with hidden+ignored files
for _, code in ipairs({'<M-p>', '<A-p>'}) do
    v.nnoremap({code}, function() telescope_files(true) end)
end

-- telescope commands
for _, code in ipairs({"<C-S-P>", "<D-P>"}) do
    v.nnoremap({code}, function()
        local telescope = require("telescope.builtin")
        telescope.commands()
    end)
end

-- telescope buffers
v.nnoremap({"<C-b>"}, function()
    local telescope = require("telescope.builtin")
    telescope.buffers()
end)
--
-- telescope registers
for _, code in ipairs({"<C-y>", "<D-y>"}) do
    v.nnoremap({code}, function()
        local telescope = require("telescope.builtin")
        telescope.registers()
    end)
end

-- telescope global search
for _, code in ipairs({"<C-S-F>", "<C-F>", "<D-F>"}) do
    v.nnoremap({code}, function()
        local telescope = require("telescope.builtin")

        local rg_arguments = {}

        for k,v in pairs(require('telescope.config').values.vimgrep_arguments) do
            rg_arguments[k] = v
        end

        table.insert(rg_arguments, "--hidden")
        table.insert(rg_arguments, "--no-ignore")

        local cmd_args = {
            "-g", "!node_modules/**/*",
            "-g", "!venv/**/*",
            "-g", "!.git/**/*"
        }

        for _, arg in pairs(cmd_args) do
            table.insert(rg_arguments, arg)
        end

        telescope.live_grep({ vimgrep_arguments = rg_arguments })
    end)
end

-- telescope asynctasks
for _, code in ipairs({"<M-F9>", "<A-F9>"}) do
    v.nnoremap({code}, function()
        local telescope = require("telescope")
        telescope.extensions.asynctasks.all()
    end)
end

-- telescope select/change filetype
for _, code in ipairs({"<C-S-L>", "<C-L>", "<D-L>"}) do
    v.nnoremap({code}, function()
        local telescope = require("telescope.builtin")
        telescope.filetypes()
    end)
end

-- telescope vimspector
for  _, code in ipairs({"<S-F9>"}) do
    v.nnoremap({code}, function()
        require('telescope').extensions.vimspector.configurations()
    end)
end

-- undo with ctrl/cmd-z in insert mode
v.inoremap({"<C-z>"}, "<ESC>ui")
v.inoremap({"<D-z>"}, "<ESC>ui")

-- vim-test test nearest test
v.nmap({"<C-F10>"}, v.cmd.TestNearest)

-- - and + to go back to previous position
v.nnoremap({"<M-->"}, "<C-o>")
v.nnoremap({"<M-KMinus>"}, "<C-o>")
v.nnoremap({"<M-+>"}, "<C-i>")
v.nnoremap({"<M-KPlus>"}, "<C-i>")

-- GoTo code navigation.
v.nmap({"<silent>", "<F12>"}, "<Plug>(coc-definition)")
v.imap({"<silent>", "<F12>"}, "<Plug>(coc-definition)")


-- Symbol renaming.
v.nmap({"<F2>"}, "<Plug>(coc-rename)")
v.nmap({"<silent>", "<F5>"},  "<Plug>(coc-codelens-action)")
v.nmap({"<silent>", "<F6>"}, "<Plug>(coc-codeaction-line)")
v.nmap({"<silent>", "<F7>"}, v.cmd.CocDiagnostics)


-- Use <c-space> to trigger completion.
v.inoremap("<silent><expr> <c-space>", v.cmd["coc#refresh()"])

-- Make <CR> auto-select the first completion item and notify coc.nvim to
-- format on enter, <cr> could be remapped by other vim plugin
v.inoremap("<silent><expr> <cr>", "pumvisible() ? coc#_select_confirm(): \"\\<C-g>u\\<CR>\\<c-r>=coc#on_enter()\\<CR>\"")


-- vimspector mappings
v.nmap({"<F8>"}, "<Plug>VimspectorToggleBreakpoint")
--v.nmap({"<F1>"}, ":call vimspector#Launch()<CR>")
v.nmap({"<F1>"}, require('telescope').extensions.vimspector.configurations)
v.nmap({"<C-F2>"}, ":VimspectorReset<CR>:tabprevious<CR>")
local vimspector_bindings = {
    ["<F5>"] = "<Plug>VimspectorContinue",
    ["<F6>"] = "<Plug>VimspectorStepOut",

    ["<F9>"] = "<Plug>VimspectorStepInto",
    ["<F10>"] = "<Plug>VimspectorStepOver",
}
v.autocmd("User", "VimspectorJumpedToFrame", function()
    for code, cmd in pairs(vimspector_bindings) do
        v.nmap({code}, cmd)
    end
end)
v.autocmd("User", "VimspectorDebugEnded", function()
    for code, cmd in pairs(vimspector_bindings) do
        pcall(v.nunmap, {code}, cmd)
    end
end)
