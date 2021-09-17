local luv = vim.loop
local v = require("utils")
local user_profile = require("user_profile")

local nvim_lsp = require('lspconfig')
local lspinstall = require('lspinstall')

-- status in the tabline
local lsp_status = require('lsp-status')
lsp_status.register_progress()

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

    local lsp_status_extension = lsp_status.extensions[server]
    local lsp_handlers = nil
    if lsp_status_extension then lsp_handlers = lsp_status_extension.setup() end

    local config = {capabilities = capabilities, handlers = lsp_handlers, on_attach = lsp_on_attach.on_attach}

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

local M = {}

M.cursor_hold_timer = nil

-- adds a small delay before showing the line diagnostics
M.cursor_hold = function()
    local timeout = 500

    local bufnr = 0
    local line_nr = (vim.api.nvim_win_get_cursor(0)[1] - 1)

    if M.cursor_hold_timer then
        M.cursor_hold_timer:stop()
        M.cursor_hold_timer:close()
        M.cursor_hold_timer = nil
    end

    M.cursor_hold_timer = luv.new_timer()

    M.cursor_hold_timer:start(timeout, 0, vim.schedule_wrap(function()
        if M.cursor_hold_timer then
            M.cursor_hold_timer:stop()
            M.cursor_hold_timer:close()
            M.cursor_hold_timer = nil
        end
        require'lspsaga.diagnostic'.show_line_diagnostics(nil, bufnr, line_nr)
    end))

end

return M
