local second_leader = "z"
local kitty_escape_leader = "<Char-0xff>"

-- this is to avoid inserting weird characters (comming from kitty custom maps) in insert mode or terminal mode
local function create_kitty_keymap(code, no_insert_mode_handler, no_terminal_mode_handler)
	if not no_insert_mode_handler then
		--v.inoremap({ kitty_escape_leader .. code }, "<Nop>")
		--v.inoremap({ kitty_escape_leader .. code }, "<ESC>")
		vim.keymap.set({ "i" }, kitty_escape_leader .. code, "<ESC>")
	end

	if not no_terminal_mode_handler then
		--v.inoremap({ kitty_escape_leader .. code }, "<Nop>")
		--v.tnoremap({ kitty_escape_leader .. code }, "<C-\\><C-N>")
		vim.keymap.set({ "t" }, kitty_escape_leader .. code, "<C-\\><C-N>")
	end

	return kitty_escape_leader .. code
end

-- save with ctrl-s/command-s
for _, code in ipairs({ "<D-s>", "<C-s>", create_kitty_keymap("ds") }) do
	--v.nnoremap({ code }, ":w<CR>")
	--v.inoremap({ code }, "<ESC>:w<CR>i")
	vim.keymap.set({ "n" }, code, ":w<CR>")
	vim.keymap.set({ "i" }, code, "<ESC>:w<CR>i")
end

-- vertical split with ctrl-\ | command-\
vim.keymap.set({ "n" }, "<D-\\>", ":vsplit<CR>")
vim.keymap.set({ "n" }, "<C-\\>", ":vsplit<CR>")
vim.keymap.set({ "n" }, create_kitty_keymap("m\\"), ":vsplit<CR>")

-- ctrl/cmd-/ to toggle comment, C-_ can also be interpreted as ctrl-/
for _, code in ipairs({ "<C-_>", "<C-/>", "<D-/>" }) do
	vim.keymap.set({ "i" }, code, "<Plug>NERDCommenterInsert", { remap = true })
	vim.keymap.set({ "n" }, code, "<Plug>NERDCommenterToggle<CR>", { remap = true })
	vim.keymap.set({ "v" }, code, "<Plug>NERDCommenterToggle<CR>gv", { remap = true })
end

-- Alt-Shift-Left/Right to move to previous next position
vim.keymap.set({ "n" }, "<M-S-Right>", "<C-I>")
vim.keymap.set({ "n" }, "<M-S-Left>", "<C-O>")

-- ctrl/cmd-d kill buffer without losing split/window
vim.keymap.set({ "n" }, "<C-d>", ":BD<CR>")
vim.keymap.set({ "n" }, "<D-d>", ":BD<CR>")

-- ctrl/cmd-q kill the current split/window
vim.keymap.set({ "n" }, "<C-q>", ":q<CR>")
vim.keymap.set({ "n" }, "<D-q>", ":q<CR>")

-- Increment numbers with C-z. Decrement with C-x
vim.keymap.set({ "n" }, "<C-z>", "<C-a>", { remap = true })

-- open scratch file in a floating window
vim.keymap.set({ "n" }, "<leader>s", function()
	require("scratches").open_scratch_file_floating()
end)

-- change focus splits
for _, code in ipairs({ "<D-Right>", "<C-l>", second_leader .. "<Right>", create_kitty_keymap("mright") }) do
	vim.keymap.set({ "n" }, code, "<c-w>l", { silent = true })
end

for _, code in ipairs({ "<D-left>", "<C-h>", second_leader .. "<Left>", create_kitty_keymap("mleft") }) do
	vim.keymap.set({ "n" }, code, "<c-w>h", { silent = true })
end

for _, code in ipairs({ "<D-Up>", "<C-k>", second_leader .. "<Up>", create_kitty_keymap("mup") }) do
	vim.keymap.set({ "n" }, code, "<c-w>k", { silent = true })
end

for _, code in ipairs({ "<D-Down>", "<C-j>", second_leader .. "<Down>", create_kitty_keymap("mdown") }) do
	vim.keymap.set({ "n" }, code, "<c-w>j", { silent = true })
end

for i = 1, 9, 1 do
	for _, key in ipairs({ "<D-k" .. i .. ">", "<D-" .. i .. ">", create_kitty_keymap("m" .. i, false, true) }) do
		vim.keymap.set({ "n" }, key, ":" .. i .. "wincmd w<CR>", { silent = true })
		vim.keymap.set({ "t" }, key, "<C-\\><C-N>:" .. i .. "wincmd w<CR>", { silent = true })
	end

	-- only bind this on linux, not macos
	-- ctrl-<number>
	if vim.fn.has("macunix") == 0 then
		for _, key in ipairs({ "<C-k" .. i .. ">", "<C-" .. i .. ">" }) do
			vim.keymap.set({ "n" }, key, ":" .. i .. "wincmd w<CR>", { silent = true })
			vim.keymap.set({ "t" }, key, "<C-\\><C-N>:" .. i .. "wincmd w<CR>", { silent = true })
		end
	end
end

-- insert mode ctrl/cmd+v paste from clipboard
for _, code in ipairs({ "<C-v>", "<D-v>" }) do
	vim.keymap.set({ "i" }, code, '<ESC>"+pa', { silent = true })
	vim.keymap.set({ "t" }, code, '<C-\\><C-N>"+pa', { silent = true })
end
-- same as above, but maps ctrl+shift+v instead of ctrl+v. still uses cmd-v
for _, code in ipairs({ "<C-S-V>", "<D-v>" }) do
	vim.keymap.set({ "c" }, code, "<C-r>+")
end

-- visual mode ctrl/cmd+c copy to clipboard
vim.keymap.set({ "c" }, "<C-c>", '"+y', { silent = true })
vim.keymap.set({ "v" }, "<D-c>", '"+y', { silent = true })

-- PageUp PageDown to navigate through tabs
vim.keymap.set({ "n" }, "<C-PageUp>", "<cmd>tabprevious<cr>")
vim.keymap.set({ "n" }, "<C-PageDown>", "<cmd>tabnext<cr>")

-- ctrl/cmd-a select all in insert and normal modes
for _, code in ipairs({ "<D-a>", create_kitty_keymap("da", true, true) }) do
	--v.inoremap({ code }, "<ESC>ggVG")
	vim.keymap.set({ "n" }, code, "ggVG")
end

-- toggle Undotree with F4
vim.keymap.set({ "n" }, "<F4>", "<cmd>UndotreeToggle<cr>")

-- alt-b to create a new buffer in the current split
vim.keymap.set({ "n" }, "<M-b>", "<cmd>enew<cr>")

-- ctrl/cmd-f search in current buffer
for _, code in ipairs({ "<C-f>", "<D-f>" }) do
	vim.keymap.set({ "n" }, code, "/")
end

-- visual mode searches for the selected text
vim.keymap.set({ "v" }, "<C-f>", "y/<C-R>=escape(@\",'/\\')<CR><CR>")
vim.keymap.set({ "v" }, "<D-f>", "y/<C-R>=escape(@\",'/\\')<CR><CR>")

-- visual mode replace the currently selected text
vim.keymap.set({ "v" }, "<C-h>", "y:%s/<C-R>=escape(@\",'/\\')<CR>/")
vim.keymap.set({ "v" }, "<D-h>", "y:%s/<C-R>=escape(@\",'/\\')<CR>/")

-- ctrl-enter in insert mode to create new line below
vim.keymap.set({ "i" }, "<C-CR>", "<ESC>o")
vim.keymap.set({ "i" }, create_kitty_keymap("ccr", true), "<ESC>o")
-- shift-enter in insert mode to create new line above
vim.keymap.set({ "i" }, "<S-CR>", "<ESC>O")
vim.keymap.set({ "i" }, create_kitty_keymap("scr", true), "<ESC>O")

-- remove search highlight on ESC
vim.keymap.set({ "n" }, "<ESC>", ":noh<cr>")

-- fold keys
if vim.fn.has("macunix") then
	vim.keymap.set({ "n" }, "<D-[>", "<cmd>foldclose<cr>")
	vim.keymap.set({ "n" }, "<D-]>", "<cmd>foldopen<cr>")

	vim.keymap.set({ "n" }, "<M-[>", "<cmd>foldclose<cr>")
	vim.keymap.set({ "n" }, "<M-]>", "<cmd>foldopen<cr>")
else
	vim.keymap.set({ "n" }, "<C-[>", "<cmd>foldclose<cr>")
	vim.keymap.set({ "n" }, "<C-]>", "<cmd>foldopen<cr>")
end

-- delete current line in insert mode with shift-del
vim.keymap.set({ "i" }, "<S-Del>", "<ESC>ddi")

-- line movement
vim.keymap.set({ "n" }, "<M-Down>", ":m .+1<CR>==")
vim.keymap.set({ "n" }, "<M-Up>", ":m .-2<CR>==")
vim.keymap.set({ "i" }, "<M-Down>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set({ "i" }, "<M-Up>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set({ "v" }, "<M-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set({ "v" }, "<M-Up>", ":m '<-2<CR>gv=gv")

-- duplicate line with Ctrl/cmd+Shift+D
vim.keymap.set({ "n" }, "<C-S-D>", "yyp")
vim.keymap.set({ "n" }, "<S-D-D>", "yyp")
vim.keymap.set({ "i" }, "<C-S-D>", "<ESC>yypi")
vim.keymap.set({ "i" }, "<S-D-D>", "<ESC>yypi")

-- word movement with Alt-Left and Alt-Right
vim.keymap.set({ "n", "v" }, "<M-Left>", "b")
vim.keymap.set({ "i" }, "<M-Left>", "<ESC>b")
-- forward
vim.keymap.set({ "n", "v" }, "<M-Right>", "w")
vim.keymap.set({ "i" }, "<M-Right>", "<ESC>lw")

-- hop.nvim
vim.keymap.set({ "n" }, "<leader>g", function()
	print("enter 2 char pattern: ")
	require("hop").hint_char2()
end)
vim.keymap.set({ "n" }, "<leader>f", function()
	require("hop").hint_words()
end)

-- floaterm keybindings
for _, code in ipairs({ "<A-F12>", "<M-F12>", create_kitty_keymap("af12", true, true) }) do
	vim.keymap.set({ "n" }, code, "<cmd>FloatermToggle<cr>")
	vim.keymap.set({ "i" }, code, "<ESC>:FloatermToggle<CR>")
	vim.keymap.set({ "t" }, code, "<C-\\><C-N>:FloatermToggle<CR>")
end

-- terminal keymaps
-- exit terminal mode with <ESC>
vim.keymap.set({ "t" }, "<ESC>", "<C-\\><C-N>")

-- alt movements
vim.keymap.set({ "t" }, "<M-Left>", "<M-B>")
vim.keymap.set({ "t" }, "<M-Right>", "<M-F>")

-- page up/down to move between terms
vim.keymap.set({ "t" }, "<C-PageDown>", "<C-\\><C-N>:FloatermNext<CR>")
vim.keymap.set({ "t" }, "<C-PageUp>", "<C-\\><C-N>:FloatermPrev<CR>")

-- alt-n to create a new term
vim.keymap.set({ "t" }, "<M-n>", "<C-\\><C-N>:FloatermNew<CR>")

-- ctrl-q to kill current term
--v.tnoremap({ "<C-q>" }, "<C-\\><C-N>:FloatermKill<CR>")

-- alt-t to open ranger in a float terminal
vim.keymap.set({ "n" }, "<C-T>", "<cmd>Ranger<cr>")

-- ctrl-c will close processes in normal mode
vim.api.nvim_create_augroup("KeyMapsTermOpen", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
	group = "KeyMapsTermOpen",
	callback = function()
		vim.keymap.set({ "n" }, "<C-c>", "i<C-c>", { buffer = true })
		vim.keymap.set({ "n" }, "<C-d>", ":BD!<CR>", { buffer = true })
	end,
})

-- forcily close buffer and split
--v.autocmd("TermOpen", "*", function()
--v.nnoremap({ "<buffer>", "<C-q>" }, ":bd!<CR>")
--end)

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
	vim.keymap.set({ "n" }, code, function()
		telescope_files(false)
	end)
end

-- telescope files, but with hidden+ignored files
for _, code in ipairs({ "<M-p>", "<A-p>" }) do
	vim.keymap.set({ "n" }, code, function()
		telescope_files(true)
	end)
end

-- telescope commands
for _, code in ipairs({
	"<C-S-P>",
	"<S-D-P>",
	"<D-P>",
	second_leader .. "p",
	create_kitty_keymap("csp"),
	create_kitty_keymap("msp"),
}) do
	vim.keymap.set({ "n" }, code, function()
		local telescope = require("telescope.builtin")
		telescope.builtin()
	end)
end

-- telescope buffers
vim.keymap.set({ "n" }, "<C-b>", function()
	local telescope = require("telescope.builtin")
	telescope.buffers()
end)
--

-- telescope global search
for _, code in ipairs({ "<C-S-F>", "<C-F>", "<S-D-F>", "<D-F>", create_kitty_keymap("mf") }) do
	vim.keymap.set({ "n" }, code, function()
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

		require("telescope").extensions.live_grep_args.live_grep_args({ vimgrep_arguments = rg_arguments })
	end)
end

-- telescope lsp symbols
for _, code in ipairs({ "<D-g>", "<C-g>", create_kitty_keymap("dg") }) do
	vim.keymap.set({ "n" }, code, function()
		require("telescope.builtin").lsp_dynamic_workspace_symbols()
	end)
end

-- telescope asynctasks
for _, code in ipairs({ "<C-F9>" }) do
	vim.keymap.set({ "n" }, code, function()
		local telescope = require("telescope")
		telescope.extensions.asynctasks.all()
	end)
end

-- telescope select/change filetype
for _, code in ipairs({ "<C-S-L>", "<S-D-L>", "<D-L>", second_leader .. "l", create_kitty_keymap("csl") }) do
	vim.keymap.set({ "n" }, code, function()
		local telescope = require("telescope.builtin")
		telescope.filetypes()
	end)
end

-- undo with ctrl/cmd-z in insert mode
vim.keymap.set({ "i" }, "<C-z>", "<ESC>ui")
vim.keymap.set({ "i" }, "<D-z>", "<ESC>ui")

--vim-test test nearest test
--v.nmap({ "<C-F10>" }, v.cmd.TestNearest)

-- - and + to go back to previous position
--vim.keymap.set({ "n" }, "<M-->", "<C-o>")
--vim.keymap.set({ "n" }, "<M-KMinus>", "<C-o>")
--vim.keymap.set({ "n" }, "<M-+>", "<C-i>")
--vim.keymap.set({ "n" }, "<M-KPlus>", "<C-i>")

-- dap mappings
-- telescope
for _, code in ipairs({ "<F9>" }) do
	vim.keymap.set({ "n" }, code, function()
		require("telescope").extensions.dap.commands()
	end)
end

vim.keymap.set({ "n" }, "<leader>b", function()
	require("dap").toggle_breakpoint()
end)
vim.keymap.set({ "n" }, "<leader>x", function()
	require("dap").close()
	require("dapui").close()
end)
local debugger_bindings = {
	["<leader>c"] = function()
		require("dap").continue()
	end,
	["<leader>o"] = function()
		require("dap").step_out()
	end,

	["<leader>i"] = function()
		require("dap").step_into()
	end,
	["<leader>n"] = function()
		require("dap").step_over()
	end,
}
for code, cmd in pairs(debugger_bindings) do
	vim.keymap.set({ "n" }, code, cmd)
end

-- toggle sidebar
vim.keymap.set({ "n" }, "<F3>", ":SidebarNvimToggle<CR>")

-- harpoon
vim.keymap.set({ "n" }, "<leader>h", function()
	require("harpoon.ui").toggle_quick_menu()
end)

vim.keymap.set({ "n" }, "<leader>ha", function()
	require("harpoon.mark").add_file()
end)

for i = 1, 4, 1 do
	vim.keymap.set({ "n" }, "<leader>" .. i, function()
		require("harpoon.ui").nav_file(i)
	end)
end

vim.keymap.set({ "n" }, "<leader>t", function()
	require("harpoon.term").gotoTerminal(1)
end)
vim.keymap.set({ "n" }, "<leader>hc", function()
	require("harpoon.cmd-ui").toggle_quick_menu() -- shows the commands menu
end)
for i = 1, 4, 1 do
	vim.keymap.set({ "n" }, "<leader>hc" .. i, function()
		require("harpoon.term").sendCommand(1, i) -- sends command i to term 1
	end)
end

local function snip_map(lhs, fn)
	vim.keymap.set({ "i", "s" }, lhs, fn, { silent = true })
end

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
snip_map("<c-k>", function()
	local ls = require("luasnip")
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end)

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
snip_map("<c-j>", function()
	local ls = require("luasnip")
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end)

-- <c-l> is selecting within a list of options.
-- advance choice node forward
snip_map("<c-l>", function()
	local ls = require("luasnip")
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

-- C-i toggle booleans true <-> false
vim.keymap.set("n", "<C-e>", function()
	local word = vim.fn.expand("<cword>")

	local word_mapping = {
		["true"] = "false",
		["True"] = "False",
		["on"] = "off",
	}

	word_mapping = vim.tbl_add_reverse_lookup(word_mapping)

	local new_word = word_mapping[word]

	if not new_word then
		return
	end

	local cmd = "normal ciw" .. new_word

	vim.cmd(cmd)
end)

-- refactoring stuff
vim.keymap.set("v", "<leader>rr", function()
	require("telescope").extensions.refactoring.refactors()
end)

-- add debug print calls
vim.keymap.set("n", "<leader>rp", function()
	require("refactoring").debug.printf({ below = false })
end)

-- Print var
-- In normal mode it selects the word under the cursor
vim.keymap.set("v", "<leader>rv", function()
	require("refactoring").debug.print_var({})
end)
vim.keymap.set("n", "<leader>rv", function()
	vim.cmd("normal viw")
	require("refactoring").debug.print_var({})
end)

-- Cleanup function: this remap should be made in normal mode
vim.keymap.set("n", "<leader>rc", function()
	require("refactoring").debug.cleanup({})
end)
