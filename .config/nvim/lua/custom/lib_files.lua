-- some helpers to make library files (node_modules, venv, etc) read-only and non-modifiable and other stuff

-- inspired by: https://github.com/augustocdias/gatekeeper.nvim/blob/main/lua/gatekeeper.lua
-- and https://neovim.discourse.group/t/is-it-possible-to-disable-lsp-in-node-modules-directory-file/444/4
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("lib_files", { clear = true }),
	pattern = {
		"*/node_modules/*",
		"*/venv/*",
		"/opt/homebrew/Cellar/go/*",
		"*/.cargo/registry/src/*",
		"*/.rustup/toolchains/*",
	},
	desc = "make library files read-only and non-modifiable",
	callback = function()
		vim.bo.readonly = true
		vim.bo.modifiable = false
	end,
})
