
local eslint = {
    lintCommand = './node_modules/.bin/eslint -f visualstudio --stdin --stdin-filename ${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {"%f(%l,%c): %tarning %m", "%f(%l,%c): %rror %m"}
}

local prettier = {
    formatCommand = './node_modules/.bin/prettier --stdin-filepath ${INPUT}',
    formatStdin = true,
}

local configs = {
    lua = {
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
   },
   efm = {
    init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {
                --{formatCommand = "lua-format -i", formatStdin = true}
            },
            javascript = { eslint, prettier },
            typescript = { eslint, prettier },
            typescriptreact = { eslint, prettier },
            javascriptreact = { eslint, prettier },
            ["javascript.jsx"] = { eslint, prettier },
            ["typescript.tsx"] = { eslint, prettier },
            yaml = { prettier },
            json = { prettier },
            html = { prettier },
        }
    }
   }
}


return configs
