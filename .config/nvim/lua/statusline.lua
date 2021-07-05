local v = require("utils")

local lualine = require('lualine')

lualine.setup({
    options = {
        theme = "codedark",
    },
    sections = {
        lualine_x = {{'diagnostics', {sources = {"coc"}}}, 'encoding', 'fileformat', 'filetype'}
    }
})
