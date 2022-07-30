local user_profile = require("custom.uprofile")
local mason = require("mason")
local mason_cmd = require("mason.api.command")

mason.setup()

local common_pkgs = { "stylua" }

-- Lsp servers are set in "custom/lsp.lua"
local pkgs = user_profile.with_profile_table({
	default = vim.tbl_flatten({ common_pkgs, { "luacheck" } }),
	work = vim.tbl_flatten({ common_pkgs, "actionlint" }),
})

vim.api.nvim_create_user_command("DepsInstall", function()
	mason_cmd.MasonInstall(pkgs)
end, {})
