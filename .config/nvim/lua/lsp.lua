local v = require("utils")
local user_profile = require("user_profile")

local nvim_lsp = require('lspconfig')
local lspinstall = require('lspinstall')

-- configs
local configs = require("lsp_languages")
local lsp_on_attach = require("lsp_on_attach")

-- local servers = { "python", "rust", "typescript", "go", "lua" }
local servers = user_profile.with_profile_table({
    default = {"efm", "lua", "typescript", "go"},
    work = {"efm", "lua", "typescript"}
})

-- config that activates keymaps and enables snippet support
local function make_config(server)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {'documentation', 'detail', 'additionalTextEdits'}
    }
    local config = {capabilities = capabilities, on_attach = lsp_on_attach.on_attach}

    local server_config = configs[server] or {}
    if server_config.on_attach ~= nil then config.on_attach = server_config.on_attach end

    return vim.tbl_extend("force", server_config, config)
end

local function setup_servers()
    lspinstall.setup()

    for _, lsp in ipairs(lspinstall.installed_servers()) do
        local config = make_config(lsp)
        nvim_lsp[lsp].setup(config)
    end
end

setup_servers()

lspinstall.post_install_hook = function()
    setup_servers() -- reload installed servers
end

v.cmd["UpdateLSP"] = function() for _, lang in ipairs(servers) do v.cmd.LspInstall(lang) end end
