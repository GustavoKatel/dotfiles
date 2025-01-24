local code_blocks = require("custom.ts_ls.code_blocks")
local requests = require("custom.ts_ls.requests")
local filenames = require("custom.ts_ls.filenames")

---@type OptionsSetup
return {
	code_lenses = {
		code_blocks.code_lenses,
		requests.code_lenses,
		filenames.code_lenses,
	},
	code_actions = {
		code_blocks.code_actions,
		requests.code_actions,
		filenames.code_actions,
	},
}
