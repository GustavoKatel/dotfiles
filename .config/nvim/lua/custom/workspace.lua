local autosession = require("auto-session")

-- v.v.g.workspace_session_directory = vim.env.HOME .. "/.config/nvim/sessions/"

-- v.v.g.workspace_persist_undo_history = 0

-- v.v.g.workspace_autosave = 0

-- v.v.g.workspace_dir_replace_char = "_"

local function disable_ts_context()
	require("treesitter-context").disable()
end

local function close_dadbod_ui()
	vim.cmd("DBUIClose")
end

local function close_edgy()
	require("edgy").close()
end

autosession.setup({
	root_dir = vim.fn.stdpath("data") .. "/sessions/",
	enabled = true,
	pre_save_cmds = { disable_ts_context, close_dadbod_ui, close_edgy },
	post_save_cmds = {},
	post_delete_cmds = {},
	post_restore_cmds = {},
})
