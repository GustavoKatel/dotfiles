local autosession = require("auto-session")

-- v.v.g.workspace_session_directory = vim.env.HOME .. "/.config/nvim/sessions/"

-- v.v.g.workspace_persist_undo_history = 0

-- v.v.g.workspace_autosave = 0

-- v.v.g.workspace_dir_replace_char = "_"

local function disable_ts_context()
	require("treesitter-context").disable()
end

local function close_all_aerial_buffers()
	require("aerial").close_all()
end

autosession.setup({
	auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
	auto_session_enabled = true,
	pre_save_cmds = { disable_ts_context, close_all_aerial_buffers },
	post_save_cmds = {},
	post_delete_cmds = {},
	post_restore_cmds = {},
})
