local v = require("utils")

local nvim_lsp = require 'lspconfig'
local completion = require 'completion'
local lspinstall = require'lspinstall'


local servers = { "python", "rust", "typescript", "go", "lua" }

local function setup_servers()
    lspinstall.setup()

    for _, lsp in ipairs(lspinstall.installed_servers()) do
        if lsp == "lua" then
            nvim_lsp[lsp].setup {
                on_attach = completion.on_attach,
                init_options = {
                    codelenses = {
                        test = true,
                    },
                },
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                            -- Setup your lua path
                            path = vim.split(package.path, ';')
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {'vim', 'use'}
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
                        }
                    }
                }
            }
        else
            nvim_lsp[lsp].setup { on_attach = completion.on_attach }
        end
    end
end

setup_servers()

lspinstall.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

v.cmd["UpdateLSP"] = function()
    for _, lang in ipairs(servers) do
        v.cmd.LspInstall(lang)
    end
end
