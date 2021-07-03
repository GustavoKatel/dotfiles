local v = require("utils")

local treesitter_config = require("nvim-treesitter.configs")

treesitter_config.setup {
    highlight = {
        enable = true,
        use_languagetree = false,
        custom_captures = {},
    }
}
