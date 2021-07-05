local v = require("utils")
local lualine = require('lualine')

local function lualine_custom_winnr()
    return " "..v.fn.winnr()
end

lualine.setup({
    options = {
        theme = "codedark",
    },
    sections = {
        lualine_c = {
            {
              'filename',
              file_status = false, -- displays file status (readonly status, modified status)
              path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        },
        lualine_x = {{lualine_custom_winnr}, 'diff', 'fileformat', 'filetype'}
    },
    inactive_sections = {
        lualine_x = {{lualine_custom_winnr}, 'location'}
    }
})
