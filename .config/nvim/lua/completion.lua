require'compe'.setup {
    enabled = true,
    autocomplete = true,
    source = {
        nvim_lsp = true,
        nvim_lua = true,
        path = true,
        buffer = true,
        calc = false,
        vsnip = false,
        ultisnips = true,
        luasnip = false
    }
}
