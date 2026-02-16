require("custom.plugins")
require("custom.helpers")
require("custom.options")
require("custom.filetype")
require("custom.keybindings")
require("custom.floaterm")
require("custom.title")
require("custom.treesitter")
require("custom.workspace")
require("custom.git_utils")

require("custom.deps")
require("custom.lsp")
require("custom.snips")
require("custom.dap_setup")
require("custom.neotest")
require("custom.lib_files")

require("custom.folding_utils")

require("custom.colorscheme")
require("custom.statusline")

require("custom.quickfix_window")

require("custom.scratches")

require("custom.terminal")

require("custom.paster")

require("custom.dbs_local_project_config")
require("custom.project").setup()

require("custom.remote_ui_helpers")

require("custom.overseer.overseer_local_project_config")

require("custom.ts_ls").setup(require("custom.ts_ls.opts"))

require("custom.scripts.remote_shell_to_overseer").setup()

require("custom.terminal_handlers").setup()
