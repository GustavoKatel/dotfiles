local v = require("utils")

local sidebar = require("sidebar-nvim")
sidebar.setup({sections = {"datetime", "git-status", "lsp-diagnostics", "todos"}})
sidebar.open()

v.cmd.highlight("link SidebarNvimLspDiagnosticsTotalNumber Normal")

