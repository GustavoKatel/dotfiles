local M = {}

M.level_to_hl = {info = "None", warning = "WarningMsg", error = "ErrorMsg"}

function M.log(level, msg)
    local hl = M.level_to_hl[level] or "None"

    vim.api.nvim_command('echohl ' .. hl)
    vim.api.nvim_command("echom '" .. msg:gsub("'", "''") .. "'")
    vim.api.nvim_command('echohl None')
end

function M.info(msg) M.log("info", msg) end
function M.warning(msg) M.log("warning", msg) end
function M.error(msg) M.log("error", msg) end

return M
