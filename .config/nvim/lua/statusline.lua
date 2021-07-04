local v = require("utils")

local lualine = require('lualine')

lualine.setup({
    sections = {
        lualine_x = {{'diagnostics', {sources = {"coc"}}}, 'encoding', 'fileformat', 'filetype'}
    }
})
