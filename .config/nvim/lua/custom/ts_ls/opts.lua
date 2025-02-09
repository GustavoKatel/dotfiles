local code_blocks = require("custom.ts_ls.code_blocks")
local requests = require("custom.ts_ls.requests")
local filenames = require("custom.ts_ls.filenames")
local gotests = require("custom.ts_ls.go_tests")

---@type OptionsSetup
return {
	code_lenses = {
		code_blocks.code_lenses,
		requests.code_lenses,
		filenames.code_lenses,
		gotests.code_lenses,
	},
	code_actions = {
		code_blocks.code_actions,
		requests.code_actions,
		filenames.code_actions,
		gotests.code_actions,
	},
}
