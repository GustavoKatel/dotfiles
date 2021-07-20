local dap_install = require("dap-install")
local debuggers_config = require("dap-install.debuggers.jsnode_dbg")
local dap = require("dap")

debuggers_config.installer.install = [[
    git clone https://github.com/microsoft/vscode-node-debug2.git && cd vscode-node-debug2
    npm install
    node_modules/.bin/gulp build
]]

debuggers_config.uninstall = ""

dap_install.setup({ verbosely_call_debuggers = true })

dap_install.config("jsnode_dbg", {
    configurations = {
        {
            type = "node2",
            request = "launch",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal"
        }
    }
})


dap.configurations.typescript = {
  {
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}
