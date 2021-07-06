local v = require("utils")

local treesitter_config = require("nvim-treesitter.configs")

treesitter_config.setup {
    ensure_installed = {"rust", "go", "lua", "json", "python", "yaml", "bash", "css", "javascript", "typescript", "tsx", "html"}, 
    highlight = {
        enable = true,
        custom_captures = {},
    },
    autotag = {
       enable = true,
    }
}
