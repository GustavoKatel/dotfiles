local cmp = require 'cmp'

cmp.setup({
    snippet = {expand = function(args) vim.fn["vsnip#anonymous"](args.body) end},
    mapping = {['<CR>'] = cmp.mapping.confirm({select = true})},
    sources = {{name = 'nvim_lsp'}, {name = 'nvim_lua'}, {name = 'path'}, {name = 'buffer'}, {name = 'emoji'}},
    formatting = {
        format = function(entry, vim_item)
            -- fancy icons and a name of kind
            -- local lsp_info = require("lspkind").presets.default[vim_item.kind]

            -- set a name for each source
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                path = "[Path]",
                buffer = "[Buffer]",
                emoji = "[Emoji]"
            })[entry.source.name]
            return vim_item
        end
    }
})

