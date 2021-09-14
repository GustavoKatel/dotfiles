local v = require("utils")
local user_profile = require("user_profile")

local sidebar = require("sidebar-nvim")
sidebar.setup({
    open = true,
    sections = user_profile.with_profile_table({
        default = {"datetime", "git-status", "lsp-diagnostics", "todos"},
        work = {"datetime", "git-status", "lsp-diagnostics"}
    })
})

v.cmd.highlight("link SidebarNvimLspDiagnosticsTotalNumber Normal")
