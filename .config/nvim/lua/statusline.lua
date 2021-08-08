local v = require("utils")
local lualine = require('lualine')
local theme = require("statusline_theme")

local function lualine_custom_winnr()
    return " "..v.fn.winnr()
end

local _lualine_cache_window_count = 0

v.cmd["UpdateWindowNumber"] = function()
    local win_count = v.fn.winnr("$")
    local current_window = v.fn.winnr()

    print(_lualine_cache_window_count)

    if _lualine_cache_window_count == win_count then
        return
    end

    _lualine_cache_window_count = win_count
    v.cmd.windo("redrawstatus")
    vim.cmd(":"..current_window.."wincmd w")
end

--v.autocmd("WinEnter", "*", "UpdateWindowNumber")

lualine.setup({
    options = {
        --theme = "codedark",
        theme = theme,
        --theme = "github",
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
