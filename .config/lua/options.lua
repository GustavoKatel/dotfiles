local v = require("utils")

v.opt.encoding = "UTF-8"

-- set leader to ,
v.v.g.mapleader = ","

-- Required for operations modifying multiple buffers like rename.
v.opt.hidden = true

-- enable mouse support 😛
v.opt.mouse = "a"

v.cmd.colorscheme("codedark")

-- show line numbers
v.opt.number = true

-- always show the status line
v.opt.laststatus = 2

-- disable swap files
v.opt.swapfile = true

-- show invisible chars
v.opt.listchars = [[tab:▸ ,eol:¬,trail:⋅,extends:❯,precedes:❮]]
v.opt.showbreak = "↪"
v.opt.list = true

-- show existing tab with 4 spaces width
v.opt.tabstop = 4
-- when identing with '>', use 5 spaces width
v.opt.shiftwidth = 4

-- use spaces instead of tab
v.opt.expandtab = true

v.cmd.syntax("on")

-- gitgutter update time - this also controls .swp write delay, but since we have it disabled on line 23, this does not matter
v.opt.updatetime = 100

v.opt.termguicolors = true

-- splits window below of the focused one
v.opt.splitbelow = true
-- splits window on the right
v.opt.splitright = true

-- incremental subnstitute + preview
v.opt.inccommand = "split"

-- always keep at least 60 lines on the screen
v.opt.scrolloff = 60

-- always show sign column (gitgutter)
v.opt.signcolumn = "yes"

-- give more space displaying messages in the command line
v.opt.cmdheight = 2

-- spell checking dictionaries, enable/disable with: set [no]spell
v.opt.spelllang = {"en_us", "pt_br"}

-- enable the cursor line highlight
v.opt.cursorline = true

-- show tab line
v.opt.showtabline = 2

v.cmd.hi("illuminatedWord guibg=#424242")

v.opt.foldmethod = "marker"
