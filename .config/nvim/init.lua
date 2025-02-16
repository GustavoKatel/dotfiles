require("custom.plugins")
require("custom.helpers")
require("custom.options")
require("custom.filetype")
require("custom.keybindings")
--require("custom.asynctasks")
require("custom.floaterm")
require("custom.title")
require("custom.treesitter")
require("custom.workspace")
require("custom.git_utils")

require("custom.deps")
require("custom.lsp")
require("custom.completion")
require("custom.snips")
require("custom.dap_setup")
require("custom.neotest")
require("custom.lib_files")

require("custom.harpoon_setup")

require("custom.folding_utils")

require("custom.colorscheme")
require("custom.statusline")

require("custom.quickfix_window")

require("custom.scratches")

-- require("custom.tasks")

require("custom.terminal")

require("custom.paster")

require("custom.dbs_local_project_config")
require("custom.project").setup()

require("custom.file_browser")

require("custom.remote_ui_helpers")

require("custom.iron_repl")

require("custom.overseer.overseer_local_project_config")

require("custom.ts_ls").setup(require("custom.ts_ls.opts"))
