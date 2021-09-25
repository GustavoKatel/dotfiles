local saga = require("lspsaga")

saga.init_lsp_saga({
	code_action_keys = { quit = "<ESC>", exec = "<CR>" },
	rename_action_keys = { quit = "<ESC>", exec = "<CR>" },
})
