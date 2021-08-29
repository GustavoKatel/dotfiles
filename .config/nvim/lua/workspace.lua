local tabs = require("custom_tabs")
local autosession = require('auto-session')

-- v.v.g.workspace_session_directory = vim.env.HOME .. "/.config/nvim/sessions/"

-- v.v.g.workspace_persist_undo_history = 0

-- v.v.g.workspace_autosave = 0

-- v.v.g.workspace_dir_replace_char = "_"

autosession.setup({
    auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
    auto_session_enabled = true,
    post_save_cmds = {tabs.save},
    post_delete_cmds = {tabs.delete},
    post_restore_cmds = {tabs.load}
})
