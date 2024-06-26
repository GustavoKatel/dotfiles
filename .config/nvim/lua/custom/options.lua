vim.opt.encoding = "UTF-8"

-- set leader to ,
vim.g.mapleader = ","

-- Required for operations modifying multiple buffers like rename.
vim.opt.hidden = true

-- enable mouse support 😛
vim.opt.mouse = "a"

-- show line numbers
vim.opt.number = true
-- show relative line number only when the current window is focused
local group = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd(
	{ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" },
	{ group = group, command = "if &nu  | set rnu   | endif" }
)
vim.api.nvim_create_autocmd(
	{ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" },
	{ group = group, command = "if &nu  | set nornu | endif" }
)

-- always show the status line
vim.opt.laststatus = 2

-- disable swap files
vim.opt.swapfile = true

-- show invisible chars
vim.opt.listchars = [[tab:▸ ,eol:¬,trail:⋅,extends:❯,precedes:❮]]
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.showbreak = "↪"
vim.opt.list = true

-- show existing tab with 4 spaces width
vim.opt.tabstop = 4
-- when identing with '>', use 5 spaces width
vim.opt.shiftwidth = 4

-- use spaces instead of tab
vim.opt.expandtab = true

vim.cmd("syntax on")

-- gitgutter update time - this also controls .swp write delay, but since we have it disabled on line 23, this does not matter
vim.opt.updatetime = 100

vim.opt.termguicolors = true
vim.g.t_Co = 256 -- Support 256 colors

-- splits window below of the focused one
vim.opt.splitbelow = true
-- splits window on the right
vim.opt.splitright = true

-- incremental subnstitute + preview
vim.opt.inccommand = "split"

-- when searching use smartcase
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- always keep at least 60 lines on the screen
vim.opt.scrolloff = 60

-- give more space displaying messages in the command line
vim.opt.cmdheight = 2

-- spell checking dictionaries, enable/disable with: set [no]spell
vim.opt.spelllang = { "en_us", "pt_br" }

-- enable the cursor line highlight
vim.opt.cursorline = true

vim.opt.showtabline = 2

-- quickfix window will use last window to open files
vim.opt.switchbuf:append("uselast")

vim.opt.undofile = true

-- remove manually created folds
-- TODO: it's buggy and I'm not even using folds, why?
-- vim.opt.sessionoptions:remove("folds")
vim.opt.sessionoptions:remove("help")
vim.opt.sessionoptions:remove("terminal")

-- terminal overrides
-- no line numbers on terminals
vim.api.nvim_create_augroup("term_open_config", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
	group = "term_open_config",
	callback = function()
		vim.cmd("setlocal nonumber")
		vim.cmd("setlocal norelativenumber")
		vim.cmd("setlocal nospell")
	end,
})

-- enable window title
vim.opt.title = true

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noinsert,noselect"

-- Avoid showing message extra message when using completion
vim.opt.shortmess:append({ c = true })

vim.opt.signcolumn = "yes:2"

vim.g.vim_json_conceal = 0

vim.g.AutoPairsShortcutToggle = ""

vim.g.dashboard_default_executive = "telescope"

------------- START SPELL STUFF ---------
-- TODO: spellsitter is checking against all string nodes, which is a lot for me
-- refs:
-- https://github.com/nvim-treesitter/nvim-treesitter/discussions/3603
-- https://github.com/neovim/neovim/issues/20174
-- set spell everywhere, this works fine because of spellsitter in ./treesitter.lua
-- vim.opt.spell = true

-- set spell check for markdown files
local group_id = vim.api.nvim_create_augroup("markdown_config", { clear = true })

vim.api.nvim_create_autocmd("FileType", { group = group_id, pattern = "markdown", command = "setlocal spell" })
vim.api.nvim_create_autocmd(
	{ "BufRead", "BufNewFile" },
	{ group = group_id, pattern = "*.md", command = "setlocal spell" }
)
------------- END SPELL STUFF ---------

-- set nvr as GIT_EDITOR so we can use the current nvim as editor for git
vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"

-- this will make sure to delete the bufer once we close the git commit/rebase/config buffer
-- otherwise nvr will be waiting for us
vim.api.nvim_create_augroup("gitutilsbuffers", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "gitutilsbuffers",
	pattern = { "gitcommit", "gitrebase", "gitconfig" },
	command = "set bufhidden=delete",
})

vim.api.nvim_create_augroup("autoresizebuffers", { clear = true })
vim.api.nvim_create_autocmd({ "VimResized", "VimResume" }, {
	group = "autoresizebuffers",
	command = "wincmd =",
})
