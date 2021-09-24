local user_profile = require("user_profile")
local dap_install = require("dap-install")
local dap = require("dap")

require("dapui").setup()

dap_install.setup({
	installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
})

user_profile.with_profile_fn("default", function()
    dap_install.config("go", {})
end)

dap_install.config("jsnode", {
   configurations = { {
        name = "${file}",
        type = 'node2',
        request = 'launch',
        program = '${workspaceFolder}/${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
    } }
})

dap.configurations.typescript = {
    {
        name = "${file}",
        type = 'node2',
        request = 'launch',
        program = '${workspaceFolder}/${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
        outFiles = {
            "${workspaceRoot}/dist/**/*.js"
        }
    },
    {
        name = "jest",
        type = 'node2',
        request = 'launch',
        cwd = vim.fn.getcwd(),
        runtimeArgs = {'--inspect-brk', '${workspaceFolder}/node_modules/.bin/jest', '--no-coverage', '--', '${workspaceFolder}/${file}'},
        sourceMaps = true,
        protocol = 'inspector',
        skipFiles = {'<node_internals>/**/*.js'},
        console = 'integratedTerminal',
        port = 9229,
        outFiles = {
            "${workspaceRoot}/dist/**/*.js"
        }
    }
}
