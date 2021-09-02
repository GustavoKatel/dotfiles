local v = require("utils")
local user_profile = require("user_profile")

local sidebar = require("sidebar-nvim")
sidebar.setup({
    sections = user_profile.with_profile_table({
        default = {"datetime", "git-status", "lsp-diagnostics", "todos"},
        work = {"datetime", "git-status", "lsp-diagnostics"}
    })
})
sidebar.open()

v.cmd.highlight("link SidebarNvimLspDiagnosticsTotalNumber Normal")

