local lsp_on_attach = require("lsp_on_attach")

local eslint = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    lintIgnoreExitCode = true,
    formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
    formatStdin = true
}

local prettier = {formatCommand = './node_modules/.bin/prettier --stdin-filepath ${INPUT}', formatStdin = true}

local lua_formatter = {formatCommand = "lua-format -i", formatStdin = true}

local lua_formatter_config_file = vim.fn.fnamemodify(".lua-format.yaml", ":p")
if vim.fn.filereadable(lua_formatter_config_file) == 1 then
    lua_formatter.formatCommand = "lua-format -c " .. lua_formatter_config_file .. " -i"
end

local configs = {
    lua = {
        init_options = {codelenses = {test = true}},
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
                    globals = {'vim', 'use', 'hs'}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                        [vim.fn.expand('/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/')] = true
                    }
                }
            }
        }
    },
    typescript = {
        on_attach = function(client, bufnr, ...)
            client.resolved_capabilities.document_formatting = false
            return lsp_on_attach.on_attach(client, bufnr, ...)
        end
    },
    efm = {
        init_options = {documentFormatting = true},
        settings = {
            rootMarkers = {".git/"},
            languages = {
                lua = {lua_formatter},
                javascript = {eslint, prettier},
                typescript = {eslint, prettier},
                typescriptreact = {eslint, prettier},
                javascriptreact = {eslint, prettier},
                ["javascript.jsx"] = {eslint, prettier},
                ["typescript.tsx"] = {eslint, prettier},
                yaml = {prettier},
                json = {prettier},
                html = {prettier}
            }
        }
    }
}

return configs
