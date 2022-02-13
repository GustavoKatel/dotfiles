local v = require("utils")

local second_leader = "z"
local kitty_escape_leader = "<Char-0xff>"

-- this is to avoid inserting weird characters (comming from kitty custom maps) in insert mode or terminal mode
local function create_kitty_keymap(code, no_insert_mode_handler, no_terminal_mode_handler)
	if not no_insert_mode_handler then
		--v.inoremap({ kitty_escape_leader .. code }, "<Nop>")
		v.inoremap({ kitty_escape_leader .. code }, "<ESC>")
	end

	if not no_terminal_mode_handler then
		--v.inoremap({ kitty_escape_leader .. code }, "<Nop>")
		v.tnoremap({ kitty_escape_leader .. code }, "<C-\\><C-N>")
	end

	return kitty_escape_leader .. code
end

-- save with ctrl-s/command-s
for _, code in ipairs({ "<D-s>", "<C-s>", create_kitty_keymap("ds") }) do
	v.nnoremap({ code }, ":w<CR>")
	v.inoremap({ code }, "<ESC>:w<CR>i")
end

-- vertical split with ctrl-\ | command-\
v.nnoremap({ "<D-\\>" }, ":vsplit<CR>")
v.nnoremap({ "<C-\\>" }, ":vsplit<CR>")
v.nnoremap({ create_kitty_keymap("m\\") }, ":vsplit<CR>")

-- ctrl/cmd-/ to toggle comment, C-_ can also be interpreted as ctrl-/
for _, code in ipairs({ "<C-_>", "<C-/>", "<D-/>" }) do
	v.imap({ code }, "<Plug>NERDCommenterInsert")
	v.nmap({ code }, "<Plug>NERDCommenterToggle<CR>")
	v.vmap({ code }, "<Plug>NERDCommenterToggle<CR>gv")
end

-- Alt-Shift-Left/Right to move to previous next position
v.nnoremap({ "<M-S-Right>" }, "<C-I>")
v.nnoremap({ "<M-S-Left>" }, "<C-O>")

-- ctrl/cmd-d kill buffer without losing split/window
v.nnoremap({ "<C-d>" }, ":BD<CR>")
v.nnoremap({ "<D-d>" }, ":BD<CR>")

-- ctrl/cmd-q kill the current split/window
v.nnoremap({ "<C-q>" }, ":q<CR>")
v.nnoremap({ "<D-q>" }, ":q<CR>")

-- Increment numbers with C-z. Decrement with C-x
v.nmap({ "<C-z>" }, "<C-a>")

-- toggle workspace
v.nnoremap({ "<leader>s" }, v.cmd.ToggleWorkspace)

-- change focus splits
for _, code in ipairs({ "<D-Right>", "<C-l>", second_leader .. "<Right>", create_kitty_keymap("mright") }) do
	v.nnoremap({ "<silent>", code }, "<c-w>l")
end

for _, code in ipairs({ "<D-left>", "<C-h>", second_leader .. "<Left>", create_kitty_keymap("mleft") }) do
	v.nnoremap({ "<silent>", code }, "<c-w>h")
end

for _, code in ipairs({ "<D-Up>", "<C-k>", second_leader .. "<Up>", create_kitty_keymap("mup") }) do
	v.nnoremap({ "<silent>", code }, "<c-w>k")
end

for _, code in ipairs({ "<D-Down>", "<C-j>", second_leader .. "<Down>", create_kitty_keymap("mdown") }) do
	v.nnoremap({ "<silent>", code }, "<c-w>j")
end

for i = 1, 9, 1 do
	for _, key in ipairs({ "<D-k" .. i .. ">", "<D-" .. i .. ">", create_kitty_keymap("m" .. i, false, true) }) do
		v.nnoremap({ "<silent>", key }, ":" .. i .. "wincmd w<CR>")
		v.tnoremap({ "<silent>", key }, "<C-\\><C-N>:" .. i .. "wincmd w<CR>")
	end

	-- only bind this on linux, not macos
	-- ctrl-<number>
	if v.fn.has("macunix") == 0 then
		for _, key in ipairs({ "<C-k" .. i .. ">", "<C-" .. i .. ">" }) do
			v.nnoremap({ "<silent>", key }, ":" .. i .. "wincmd w<CR>")
			v.tnoremap({ "<silent>", key }, "<C-\\><C-N>:" .. i .. "wincmd w<CR>")
		end
	end
end

-- insert mode ctrl/cmd+v paste from clipboard
for _, code in ipairs({ "<C-v>", "<D-v>" }) do
	v.inoremap({ "<silent>", code }, '<ESC>"+pa')
	v.tnoremap({ "<silent>", code }, '<C-\\><C-N>"+pa')
end
-- same as above, but maps ctrl+shift+v instead of ctrl+v. still uses cmd-v
for _, code in ipairs({ "<C-S-V>", "<D-v>" }) do
	v.cnoremap({ code }, "<C-r>+")
end

-- visual mode ctrl/cmd+c copy to clipboard
v.vnoremap({ "<silent>", "<C-c>" }, '"+y')
v.vnoremap({ "<silent>", "<D-c>" }, '"+y')

-- PageUp PageDown to navigate through tabs
v.nnoremap({ "<C-PageUp>" }, v.cmd.tabprevious)
v.nnoremap({ "<C-PageDown>" }, v.cmd.tabnext)

-- ctrl/cmd-a select all in insert and normal modes
for _, code in ipairs({ "<D-a>", create_kitty_keymap("da", true, true) }) do
	--v.inoremap({ code }, "<ESC>ggVG")
	v.nnoremap({ code }, "ggVG")
end

-- toggle Undotree with F4
v.nnoremap({ "<F4>" }, v.cmd.UndotreeToggle)

-- alt-b to create a new buffer in the current split
v.nnoremap({ "<M-b>" }, v.cmd.enew)

-- ctrl/cmd-f search in current buffer
for _, code in ipairs({ "<C-f>", "<D-f>" }) do
	v.nnoremap({ code }, "/")
end

-- visual mode searches for the selected text
v.vnoremap({ "/" }, "y/<C-R>=escape(@\",'/\\')<CR><CR>")
v.vnoremap({ "<C-f>" }, "y/<C-R>=escape(@\",'/\\')<CR><CR>")
v.vnoremap({ "<D-f>" }, "y/<C-R>=escape(@\",'/\\')<CR><CR>")

-- visual mode replace the currently selected text
v.vnoremap({ "<C-h>" }, "y:%s/<C-R>=escape(@\",'/\\')<CR>/")
v.vnoremap({ "<D-h>" }, "y:%s/<C-R>=escape(@\",'/\\')<CR>/")

-- ctrl-enter in insert mode to create new line below
v.inoremap({ "<C-CR>" }, "<ESC>o")
v.inoremap({ create_kitty_keymap("ccr", true) }, "<ESC>o")
-- shift-enter in insert mode to create new line above
v.inoremap({ "<S-CR>" }, "<ESC>O")
v.inoremap({ create_kitty_keymap("scr", true) }, "<ESC>O")

-- remove search highlight on ESC
v.nnoremap({ "<ESC>" }, v.cmd.noh)

-- fold keys
if v.fn.has("macunix") then
	v.nnoremap({ "<D-[>" }, v.cmd.foldclose)
	v.nnoremap({ "<D-]>" }, v.cmd.foldopen)
else
	v.nnoremap({ "<C-[>" }, v.cmd.foldclose)
	v.nnoremap({ "<C-]>" }, v.cmd.foldopen)
end

-- delete current line in insert mode with shift-del
v.inoremap({ "<S-Del>" }, "<ESC>ddi")

-- line movement
v.nnoremap({ "<M-Down>" }, ":m .+1<CR>==")
v.nnoremap({ "<M-Up>" }, ":m .-2<CR>==")
v.inoremap({ "<M-Down>" }, "<Esc>:m .+1<CR>==gi")
v.inoremap({ "<M-Up>" }, "<Esc>:m .-2<CR>==gi")
v.vnoremap({ "<M-Down>" }, ":m '>+1<CR>gv=gv")
v.vnoremap({ "<M-Up>" }, ":m '<-2<CR>gv=gv")

-- duplicate line with Ctrl/cmd+Shift+D
v.nnoremap({ "<C-S-D>" }, "yyp")
v.nnoremap({ "<S-D-D>" }, "yyp")
v.inoremap({ "<C-S-D>" }, "<ESC>yypi")
v.inoremap({ "<S-D-D>" }, "<ESC>yypi")

-- word movement with Alt-Left and Alt-Right
local wordLeft = { "<M-Left>", "b" }
local wordRight = { "<M-Right>", "w" }

for _, mapfunc in ipairs({ v.nnoremap, v.vnoremap }) do
	mapfunc(unpack(wordLeft))
	mapfunc(unpack(wordRight))
end
v.inoremap(wordLeft[1], "<ESC>b")
v.inoremap(wordRight[1], "<ESC>lw")

-- hop.nvim
v.nnoremap("<leader>g", function()
	print("enter 2 char pattern: ")
	require("hop").hint_char2()
end)
v.nnoremap("<leader>f", require("hop").hint_words)
v.nnoremap("<leader>w", require("nvim-window").pick)

-- floaterm keybindings
for _, code in ipairs({ "<A-F12>", "<M-F12>", create_kitty_keymap("af12", true, true) }) do
	v.nnoremap({ code }, v.cmd.FloatermToggle)
	v.inoremap({ code }, "<ESC>:FloatermToggle<CR>")
	v.tnoremap({ code }, "<C-\\><C-N>:FloatermToggle<CR>")
end

-- terminal keymaps
-- exit terminal mode with <ESC>
v.tnoremap({ "<ESC>" }, "<C-\\><C-N>")

-- alt movements
v.tnoremap({ "<M-Left>" }, "<M-B>")
v.tnoremap({ "<M-Right>" }, "<M-F>")

-- page up/down to move between terms
v.tnoremap({ "<C-PageDown>" }, "<C-\\><C-N>:FloatermNext<CR>")
v.tnoremap({ "<C-PageUp>" }, "<C-\\><C-N>:FloatermPrev<CR>")

-- alt-n to create a new term
v.tnoremap({ "<M-n>" }, "<C-\\><C-N>:FloatermNew<CR>")

-- ctrl-q to kill current term
--v.tnoremap({ "<C-q>" }, "<C-\\><C-N>:FloatermKill<CR>")

-- alt-t to open ranger in a float terminal
v.nnoremap({ "<C-T>" }, v.cmd.Ranger)

-- ctrl-c will close processes in normal mode
v.autocmd("TermOpen", "*", function()
	v.nnoremap({ "<buffer>", "<C-c>" }, "i<C-c>")
end)
-- forcily close buffer without closing split BD!
v.autocmd("TermOpen", "*", function()
	v.nnoremap({ "<buffer>", "<C-d>" }, ":BD!<CR>")
end)
-- forcily close buffer and split
--v.autocmd("TermOpen", "*", function()
--v.nnoremap({ "<buffer>", "<C-q>" }, ":bd!<CR>")
--end)
-- leave insert mode before scrolling with mouse on terminal buffers
-- TODO: this is not working 😢
v.tnoremap({ "<ScrollWheelUp>" }, "<C-\\><C-N><C-Y")
v.tnoremap({ "<ScrollWheelDown>" }, "<C-\\><C-N><C-E")
v.tnoremap({ "<2-ScrollWheelUp>" }, "<C-\\><C-N><C-Y")
v.tnoremap({ "<2-ScrollWheelDown>" }, "<C-\\><C-N><C-E")
v.tnoremap({ "<3-ScrollWheelUp>" }, "<C-\\><C-N><C-Y")
v.tnoremap({ "<3-ScrollWheelDown>" }, "<C-\\><C-N><C-E")
v.tnoremap({ "<4-ScrollWheelUp>" }, "<C-\\><C-N><C-Y")
v.tnoremap({ "<4-ScrollWheelDown>" }, "<C-\\><C-N><C-E")

-- telescope files
local function telescope_files(with_gitignored)
	local telescope = require("telescope.builtin")

	local cmd = { "rg", "--files", "--hidden" }

	if with_gitignored then
		table.insert(cmd, "--no-ignore")
	end

	local cmd_args = { "-g", "!node_modules/**/*", "-g", "!venv/**/*", "-g", "!.git/**/*" }

	for _, arg in pairs(cmd_args) do
		table.insert(cmd, arg)
	end

	telescope.find_files({ previewer = false, find_command = cmd })
end

for _, code in ipairs({ "<C-p>", "<D-p>", create_kitty_keymap("mp") }) do
	v.nnoremap({ code }, function()
		telescope_files(false)
	end)
end

-- telescope files, but with hidden+ignored files
for _, code in ipairs({ "<M-p>", "<A-p>" }) do
	v.nnoremap({ code }, function()
		telescope_files(true)
	end)
end

-- telescope commands
for _, code in
	ipairs({
		"<C-S-P>",
		"<S-D-P>",
		"<D-P>",
		second_leader .. "p",
		create_kitty_keymap("csp"),
		create_kitty_keymap("msp"),
	})
do
	v.nnoremap({ code }, function()
		local telescope = require("telescope.builtin")
		telescope.builtin()
	end)
end

-- telescope buffers
v.nnoremap({ "<C-b>" }, function()
	local telescope = require("telescope.builtin")
	telescope.buffers()
end)
--

-- telescope global search
for _, code in ipairs({ "<C-S-F>", "<C-F>", "<S-D-F>", "<D-F>", create_kitty_keymap("mf") }) do
	v.nnoremap({ code }, function()
		local rg_arguments = {}

		for k, arg in pairs(require("telescope.config").values.vimgrep_arguments) do
			rg_arguments[k] = arg
		end

		table.insert(rg_arguments, "--hidden")
		table.insert(rg_arguments, "--no-ignore")

		local cmd_args = { "-g", "!node_modules/**/*", "-g", "!venv/**/*", "-g", "!.git/**/*" }

		for _, arg in pairs(cmd_args) do
			table.insert(rg_arguments, arg)
		end

		require("telescope").extensions.live_grep_raw.live_grep_raw({ vimgrep_arguments = rg_arguments })
	end)
end

-- telescope asynctasks
for _, code in ipairs({ "<C-F9>" }) do
	v.nnoremap({ code }, function()
		local telescope = require("telescope")
		telescope.extensions.asynctasks.all()
	end)
end

-- telescope select/change filetype
for _, code in ipairs({ "<C-S-L>", "<S-D-L>", "<D-L>", second_leader .. "l", create_kitty_keymap("csl") }) do
	v.nnoremap({ code }, function()
		local telescope = require("telescope.builtin")
		telescope.filetypes()
	end)
end

-- undo with ctrl/cmd-z in insert mode
v.inoremap({ "<C-z>" }, "<ESC>ui")
v.inoremap({ "<D-z>" }, "<ESC>ui")

--vim-test test nearest test
--v.nmap({ "<C-F10>" }, v.cmd.TestNearest)

-- - and + to go back to previous position
v.nnoremap({ "<M-->" }, "<C-o>")
v.nnoremap({ "<M-KMinus>" }, "<C-o>")
v.nnoremap({ "<M-+>" }, "<C-i>")
v.nnoremap({ "<M-KPlus>" }, "<C-i>")

-- dap mappings
-- telescope
for _, code in ipairs({ "<F9>" }) do
	v.nnoremap({ code }, function()
		require("telescope").extensions.dap.commands()
	end)
end

v.nnoremap({ "<leader>b" }, require("dap").toggle_breakpoint)
v.nnoremap({ "<leader>x" }, function()
	require("dap").close()
	require("dapui").close()
end)
local debugger_bindings = {
	["<leader>c"] = require("dap").continue,
	["<leader>o"] = require("dap").step_out,

	["<leader>i"] = require("dap").step_into,
	["<leader>n"] = require("dap").step_over,
}
for code, cmd in pairs(debugger_bindings) do
	v.nnoremap({ code }, cmd)
end

-- toggle sidebar
v.nnoremap({ "<F3>" }, ":SidebarNvimToggle<CR>")

-- harpoon
v.nnoremap({ "<leader>h" }, function()
	require("harpoon.ui").toggle_quick_menu()
end)

v.nnoremap({ "<leader>a" }, function()
	require("harpoon.mark").add_file()
end)

v.nnoremap({ "<leader>t" }, function()
	require("harpoon.term").gotoTerminal(1)
end)

for i = 1, 4, 1 do
	v.nnoremap({ "<leader>" .. i }, function()
		require("harpoon.ui").nav_file(i)
	end)
end
