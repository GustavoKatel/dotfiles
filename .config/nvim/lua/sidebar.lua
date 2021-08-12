local v = require("utils")

local sidebar = require("sidebar-nvim")
sidebar.setup()
sidebar.open()

v.cmd.highlight("SidebarNvimLspDiagnosticsTotalNumber guifg=Black")
