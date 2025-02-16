local second_leader = "z"
-- kitty and wezterm
local special_escape_leader = "<Char-0xff>"

-- this is to avoid inserting weird characters (comming from kitty custom maps) in insert mode or terminal mode
local function create_special_keymap(code, no_insert_mode_handler, no_terminal_mode_handler)
	if not no_insert_mode_handler then
		vim.keymap.set({ "i" }, special_escape_leader .. code, "<ESC>")
	end

	if not no_terminal_mode_handler then
		vim.keymap.set({ "t" }, special_escape_leader .. code, "<C-\\><C-N>")
	end

	return special_escape_leader .. code
end

-- save with ctrl-s/command-s
for _, code in ipairs({ "<D-s>", "<C-s>", create_special_keymap("ds") }) do
	vim.keymap.set({ "n" }, code, ":w<CR>")
	vim.keymap.set({ "i" }, code, "<ESC>:w<CR>i")
end

-- vertical split with ctrl-\ | command-\
vim.keymap.set({ "n" }, "<D-Bslash>", ":vsplit<CR>")
vim.keymap.set({ "n" }, "<C-\\>", ":vsplit<CR>")
vim.keymap.set({ "n" }, create_special_keymap("m\\"), ":vsplit<CR>")

-- ctrl/cmd-/ to toggle comment, C-_ can also be interpreted as ctrl-/
for _, code in ipairs({ "<C-_>", "<C-/>", "<M-/>", "<D-/>" }) do
	vim.keymap.set({ "i" }, code, "<ESC>gcci", { remap = true })
	vim.keymap.set({ "n" }, code, "gcc", { remap = true })
	vim.keymap.set({ "v" }, code, "gc", { remap = true })
end
-- ctrl/cmd-shift-/ to toggle comment block-wise
for _, code in ipairs({ "<C-S-/>", create_special_keymap("cs/", true), create_special_keymap("ds/", true) }) do
	vim.keymap.set({ "i" }, code, "<ESC>gbci", { remap = true })
	vim.keymap.set({ "n" }, code, "gbc", { remap = true })
	vim.keymap.set({ "v" }, code, "gb", { remap = true })
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
	require("custom.scratches").open_scratch_file_floating()
end)

-- change focus splits
for _, code in ipairs({ "<D-Right>", "<C-l>", second_leader .. "<Right>", create_special_keymap("mright") }) do
	vim.keymap.set({ "n" }, code, "<c-w>l", { silent = true })
end

for _, code in ipairs({ "<D-left>", "<C-h>", second_leader .. "<Left>", create_special_keymap("mleft") }) do
	vim.keymap.set({ "n" }, code, "<c-w>h", { silent = true })
end

for _, code in ipairs({ "<D-Up>", "<C-k>", second_leader .. "<Up>", create_special_keymap("mup") }) do
	vim.keymap.set({ "n" }, code, "<c-w>k", { silent = true })
end

for _, code in ipairs({ "<D-Down>", "<C-j>", second_leader .. "<Down>", create_special_keymap("mdown") }) do
	vim.keymap.set({ "n" }, code, "<c-w>j", { silent = true })
end

for i = 1, 9, 1 do
	for _, key in ipairs({ "<D-k" .. i .. ">", "<D-" .. i .. ">", create_special_keymap("m" .. i, false, true) }) do
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
for _, code in ipairs({ "<D-a>", create_special_keymap("da", true, true) }) do
	--v.inoremap({ code }, "<ESC>ggVG")
	vim.keymap.set({ "n" }, code, "ggVG")
end

-- toggle Undotree with F4
vim.keymap.set({ "n" }, "<F4>", "<cmd>UndotreeToggle<cr>")

-- alt-b to create a new buffer in the current split
vim.keymap.set({ "n" }, "<M-b>", "<cmd>enew<cr>")

-- in normal mode, press "?" to search for the current word under cursor, but don't jump!
-- this sets the search register "/" to the current word
vim.keymap.set({ "n" }, "?", ":let @/='<C-R>=expand('<cword>')<CR>' | set hls<CR>")
-- visual mode searches for the selected text
vim.keymap.set({ "v" }, "?", "y:let @/='<C-R>=escape(@\",'/\\')<CR>' | set hls<CR>")

-- visual mode replace the currently selected text
vim.keymap.set({ "v" }, "<C-h>", 'y:%s#<C-R>=@"<CR>#')
vim.keymap.set({ "v" }, "<D-h>", 'y:%s#<C-R>=@"<CR>#')

-- ctrl-enter in insert mode to create new line below
vim.keymap.set({ "i" }, "<C-CR>", "<ESC>o")
vim.keymap.set({ "i" }, create_special_keymap("ccr", true), "<ESC>o")
-- shift-enter in insert mode to create new line above
vim.keymap.set({ "i" }, "<S-CR>", "<ESC>O")
vim.keymap.set({ "i" }, create_special_keymap("scr", true), "<ESC>O")

-- remove search highlight on ESC
vim.keymap.set({ "n" }, "<ESC>", ":noh<cr>")

-- {{{ fold keys
for _, key in ipairs({ "<D-[>", "<M-[>", "<C-[>", create_special_keymap("m[") }) do
	vim.keymap.set({ "n" }, key, "<cmd>foldclose<cr>")
end

for _, key in ipairs({ "<D-]>", "<M-]>", "<C-]>", create_special_keymap("m]") }) do
	vim.keymap.set({ "n" }, key, "<cmd>foldopen<cr>")
end
-- }}}

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
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("hop").hint_words()
end)
vim.keymap.set("o", "<leader>F", [[:<c-u>lua require 'tsht'.nodes()<cr>]], { silent = true, remap = true })
vim.keymap.set({ "x" }, "<leader>F", [[:lua require 'tsht'.nodes()<cr>]], { silent = true })
vim.keymap.set({ "n" }, "<leader>Fs", [[:lua require 'tsht'.move({ side = "start" })<cr>]], { silent = true })
vim.keymap.set({ "n" }, "<leader>Fe", [[:lua require 'tsht'.move({ side = "end" })<cr>]], { silent = true })

-- floaterm keybindings
for _, code in ipairs({ "<A-F12>", "<M-F12>", "<F60>", create_special_keymap("af12", true, true) }) do
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

vim.api.nvim_create_augroup("KeyMapsTermOpen", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
	group = "KeyMapsTermOpen",
	callback = function()
		-- ctrl-c will close processes in normal mode
		vim.keymap.set({ "n" }, "<C-c>", "i<C-c>", { buffer = true })
		vim.keymap.set({ "n" }, "<C-d>", ":BD!<CR>", { buffer = true })
	end,
})

vim.api.nvim_create_augroup("KeyMapsTermClose", { clear = true })
vim.api.nvim_create_autocmd("TermClose", {
	group = "KeyMapsTermClose",
	callback = function(event)
		if not vim.api.nvim_buf_is_valid(event.buf) then
			return
		end

		-- <keys> on a finished terminal will not close the window, instead it will open the prev buffer
		local keys = { "<CR>", "<C-c>", "<C-d>" }
		for _, key in ipairs(keys) do
			vim.keymap.set({ "n", "t" }, key, function()
				vim.cmd("bprev")
				vim.cmd("bdelete! " .. event.buf)
			end, { buffer = event.buf })
		end

		-- <keys> on finished terminal in terminal mode will not close the buffer
		keys = { "i", "a" }
		for _, key in ipairs(keys) do
			vim.keymap.set({ "t" }, key, "<C-\\><C-N>", { buffer = event.buf })
		end
	end,
})

-- forcily close buffer and split
--v.autocmd("TermOpen", "*", function()
--v.nnoremap({ "<buffer>", "<C-q>" }, ":bd!<CR>")
--end)

-- picker files
local function pick_files(with_gitignored)
	local opts = {
		finder = "files",
		format = "file",
		show_empty = true,
		ignored = false,
		follow = false,
		supports_live = true,
		hidden = true,
		exclude = {
			"node_modules/**/*",
			"venv/**/*",
			".git/**/*",
			"dist/**/*",
		},
	}
	if with_gitignored then
		opts.ignored = true
	end
	require("snacks").picker.smart({
		multi = {
			"buffers",
			opts,
		},
	})
end

for _, code in ipairs({ "<C-p>", "<D-p>", create_special_keymap("mp") }) do
	vim.keymap.set({ "n" }, code, function()
		pick_files(false)
	end)
end

-- picker files, but with hidden+ignored files
for _, code in ipairs({ "<M-p>", "<A-p>" }) do
	vim.keymap.set({ "n" }, code, function()
		pick_files(true)
	end)
end

-- picker commands
for _, code in ipairs({
	"<C-S-P>",
	"<S-D-p>",
	"<D-P>",
	second_leader .. "p",
	create_special_keymap("csp"),
	create_special_keymap("msp"),
}) do
	vim.keymap.set({ "n" }, code, function()
		require("snacks").picker()
	end)
end

-- picker buffers
vim.keymap.set({ "n" }, "<C-b>", function()
	require("snacks").picker.buffers()
end)

-- picker spell suggestions
vim.keymap.set({ "n" }, "z=", function()
	require("snacks").picker.spelling()
end)

-- picker global search
for _, code in ipairs({ "<C-S-F>", "<C-F>", "<S-D-F>", "<D-f>", create_special_keymap("mf") }) do
	vim.keymap.set({ "n", "v" }, code, function()
		local default_text = ""

		local mode = vim.fn.mode()
		if mode == "v" or mode == "V" or mode == "" then
			-- Get the start and end positions of the selected text
			local start_pos = vim.fn.getpos("v")
			local end_pos = vim.fn.getpos(".")

			-- Convert the positions to zero-indexed
			local start_row = start_pos[2] - 1
			local start_col = start_pos[3] - 1
			local end_row = end_pos[2] - 1
			local end_col = end_pos[3]

			-- Get the selected text
			default_text = table.concat(vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {}), "\n")
			P({
				default_text = default_text or "nil",
				start_pos = start_pos,
				end_pos = end_pos,
				start_row = start_row,
				start_col = start_col,
				end_row = end_row,
				end_col = end_col,
			})
		end

		require("snacks").picker.grep({
			search = default_text,
			hidden = true,
			ignore = false,
			exclude = {
				"node_modules/**/*",
				"venv/**/*",
				".git/**/*",
				"dist/**/*",
			},
		})
	end)
end

-- picker lsp symbols
for _, code in ipairs({ "<D-g>", "<C-g>", create_special_keymap("dg") }) do
	vim.keymap.set({ "n" }, code, function()
		require("snacks").picker.lsp_workspace_symbols()
	end)
end

-- tasks
vim.keymap.set({ "n" }, "<F9>", function()
	local overseer = require("overseer")
	-- Run a task and immediately open the floating window
	overseer.run_template({}, function(task)
		if task then
			overseer.run_action(task, "open sticky")
		end
	end)
end, { desc = "Run a task and immediately open the floating window" })

vim.keymap.set({ "n" }, "<leader><F9>", function()
	local overseer = require("overseer")
	-- Run a task and immediately open the floating window
	overseer.run_template({}, function(task)
		if task then
			overseer.run_action(task, "open float")
		end
	end)
end, { desc = "Run a task and immediately open on the float window" })

for _, code in ipairs({ "<S-F9>", "<F21>" }) do
	vim.keymap.set({ "n" }, code, function()
		local overseer = require("overseer")
		local tasks = overseer.list_tasks({ recent_first = true })
		if vim.tbl_isempty(tasks) then
			vim.notify("No tasks found", vim.log.levels.WARN)
		else
			overseer.run_action(tasks[1], "restart")
			overseer.run_action(tasks[1], "open sticky")
		end
	end, { desc = "Restart last task" })
end

for _, code in ipairs({ "<D-F9>" }) do
	vim.keymap.set({ "n" }, code, function()
		local overseer = require("overseer")
		local tasks = overseer.list_tasks({ recent_first = true })
		if vim.tbl_isempty(tasks) then
			vim.notify("No tasks found", vim.log.levels.WARN)
		else
			overseer.run_action(tasks[1], "open sticky")
		end
	end, { desc = "Open output of the last task" })
end

for _, code in ipairs({ "<C-F9>", "<F33>" }) do
	vim.keymap.set({ "n" }, code, function()
		local overseer = require("overseer")
		overseer.toggle({ direction = "left" })
	end, { desc = "Toggle the task list" })
end

-- select/change filetype
for _, code in ipairs({ "<C-S-L>", "<S-D-L>", "<D-L>", second_leader .. "l", create_special_keymap("csl") }) do
	vim.keymap.set({ "n" }, code, function()
		local fts = vim.fn.getcompletion("", "filetype")
		vim.ui.select(fts, {
			prompt = "Select Filetype: ",
		}, function(choice)
			if choice ~= nil then
				vim.cmd("set filetype=" .. choice)
			end
		end)
	end)
end

-- picker help_tags with f1
vim.keymap.set({ "n" }, "<F1>", function()
	require("snacks").picker.help()
end)

-- undo with ctrl/cmd-z in insert mode
vim.keymap.set({ "i" }, "<C-z>", "<ESC>ui")
vim.keymap.set({ "i" }, "<D-z>", "<ESC>ui")

vim.keymap.set({ "n" }, "<leader>b", function()
	require("dap").toggle_breakpoint()
end, { desc = "[dap] Add breakpoint" })

vim.keymap.set({ "n" }, "<leader>B", function()
	vim.ui.input({ promot = "Breakpoint condition: " }, function(input)
		require("dap").toggle_breakpoint(input)
	end)
end, { desc = "[dap] Add conditional breakpoint" })

vim.keymap.set({ "n" }, "<leader>a", function()
	require("dapui").toggle()
end, { desc = "[dap-ui] toggle" })
vim.api.nvim_create_user_command("DapClose", function()
	require("dap").close()
	require("dapui").close()
end, { desc = "[dap] Close dap and dap-ui" })

local debugger_bindings = {
	["<leader>c"] = {
		fn = function()
			require("dap").continue()
		end,
		desc = "[dap] Continue",
	},
	["<leader>o"] = {
		fn = function()
			require("dap").step_out()
		end,
		desc = "[dap] Step Out",
	},
	["<leader>i"] = {
		fn = function()
			require("dap").step_into()
		end,
		desc = "[dap] Step Into",
	},
	["<leader>n"] = {
		fn = function()
			require("dap").step_over()
		end,
		desc = "[dap] Step Over",
	},
}
for code, mapping in pairs(debugger_bindings) do
	vim.keymap.set({ "n" }, code, mapping.fn, { desc = mapping.desc })
end

-- toggle sidebar
vim.keymap.set({ "n" }, "<F3>", function()
	require("edgy").toggle()
end)

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
	require("custom.terminal").init_or_attach()
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

-- <C-S-K> is my jump backwards key.
-- this always moves to the previous item within the snippet
snip_map("<C-S-k>", function()
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

	local word_mapping = {}

	local function add_mapping(key, value)
		word_mapping[key] = value
		word_mapping[value] = key
	end

	add_mapping("true", "false")
	add_mapping("True", "False")
	add_mapping("on", "off")

	local new_word = word_mapping[word]

	if not new_word then
		return
	end

	local cmd = "normal ciw" .. new_word

	vim.cmd(cmd)
end)

-- open in cwd
vim.keymap.set("n", "<leader>dd", ":Oil .<CR>")
-- open in file dir
vim.keymap.set("n", "<leader>df", ":Oil<CR>")
-- open .scratches in the current folder
vim.keymap.set("n", "<leader>ds", function()
	require("custom.scratches").setup_local_folder()
	require("oil").open(".scratches")
end)
vim.keymap.set("n", "<leader>dp", function()
	local p = vim.fs.root(0, { ".nvim" })

	require("oil").open(vim.fs.joinpath(p, ".nvim"))
end)
vim.keymap.set("n", "<leader>dP", function()
	vim.fn.mkdir(".nvim", "p")
	vim.cmd.edit(".nvim/project.json")
end)

-- change inside word with ctrl+i
vim.keymap.set("n", create_special_keymap("ci"), "ciw")

-- paste custom stuff keybindings
vim.keymap.set({ "n" }, "<leader>x", function()
	require("custom.paster").select_put("c", true)
end)

vim.keymap.set({ "n" }, "<leader>X", function()
	require("custom.paster").select_put("l", true)
end)

local function toggle_quickfix(focus)
	local ids = vim.fn.getqflist({ ["winid"] = true })

	if ids and ids.winid ~= 0 then
		vim.cmd("cclose")
		return
	end

	local winnr = vim.api.nvim_get_current_win()
	vim.cmd("copen")

	if not focus then
		vim.api.nvim_set_current_win(winnr)
	end
end

-- sets diagnostics to qflist
vim.keymap.set({ "n" }, "<F7>", function()
	-- vim.diagnostic.setqflist({
	-- 	open = false,
	-- 	severity = vim.diagnostic.severity.HINT,
	-- })
	-- toggle_quickfix(true)
	require("trouble").toggle({ mode = "diagnostics", focus = true, auto_preview = false })
end, { desc = "Set diagnostics to loclist" })

-- toggle quickfix with <F8>
vim.keymap.set({ "n" }, "<F8>", function()
	toggle_quickfix(true)
end, { desc = "Toggle quickfix" })

-- toggle quickfix with <S-F8> but do not focus!
vim.keymap.set({ "n" }, "<S-F8>", function()
	toggle_quickfix(false)
end, { desc = "Toggle quickfix without focusing" })

-- copilot
vim.keymap.set(
	{ "i" },
	"<C-j>",
	"copilot#Accept('\\<CR>')",
	{ silent = true, script = true, expr = true, replace_keycodes = false }
)

-- Code navigation
vim.keymap.set("n", "<F10>", function()
	require("snacks").picker.lsp_symbols()
end, { desc = "Open code outline" })

vim.keymap.set("n", "]g", function()
	require("gitsigns").next_hunk({ preview = true })
end, { desc = "Next git hunk" })

vim.keymap.set("n", "[g", function()
	require("gitsigns").prev_hunk({ preview = true })
end, { desc = "Prev git hunk" })

vim.keymap.set({ "n", "v" }, "<leader>r", ":IronSend<CR>", { desc = "Send to IronRepl" })
