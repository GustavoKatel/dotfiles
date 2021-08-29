local v = require("utils")
local logging = require("logging")
local async = require("plenary.async")

local M = {tabs_data = {}}

M.data_dir = vim.fn.stdpath('data') .. "/sessions/"

local function escape_dir(dir) return dir:gsub("/", "__") end

local function escaped_session_name_from_cwd() return escape_dir(vim.fn.getcwd()) end

function M.get_tab_name(tabnr)
    local tab_data = M.tabs_data[tabnr]
    if tab_data then return tab_data.name end

    return tabnr
end

function M.tabline()
    local i = 1
    local line = ''
    local sep_right = "│"
    local sep_hl = "%#lualine_b_normal#"
    local current_tab = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr('$')
    while i <= last_tab do
        local is_active_tab = current_tab == i
        local hl_group = "lualine_b_normal"
        if is_active_tab then hl_group = "lualine_a_normal" end

        hl_group = string.format("%%#%s#", hl_group)

        local tab_name = M.get_tab_name(i)

        if i == 1 then
            line = line .. hl_group .. tab_name
        else
            line = line .. sep_hl .. sep_right .. hl_group .. " " .. tab_name
        end

        if i < last_tab then line = line .. " " end

        i = i + 1
    end
    return line
end

function M.rename(name)
    local current_tab_nr = vim.fn.tabpagenr()
    local tab_data = M.tabs_data[current_tab_nr]
    if tab_data then
        tab_data.name = name
        return
    end

    M.tabs_data[current_tab_nr] = {name = name}
end

local function write_file_async(filename, data)
    async.void(function()
        local err, fd = async.uv.fs_open(filename, "w", 438)
        assert(not err, err)

        err = async.uv.fs_write(fd, data)
        assert(not err, err)

        err = async.uv.fs_close(fd)
        assert(not err, err)
    end)()
end

function M.get_file_name()
    local session_name = escaped_session_name_from_cwd() .. "_tabs.json"
    local filename = M.data_dir .. session_name

    return filename
end

function M.save()
    local filename = M.get_file_name()

    local serialized = {}
    for tabnr, data in pairs(M.tabs_data) do table.insert(serialized, {tabnr = tabnr, data = data}) end

    local data = vim.fn.json_encode(serialized)
    logging.info("tabs written to: " .. filename)
    write_file_async(filename, data)
end

function M.delete()
    local filename = M.get_file_name()
    vim.fn.delete(filename)
end

local function load_async(filename)
    async.void(function()
        local err, fd = async.uv.fs_open(filename, "r", 438)
        assert(not err, err)

        ---@diagnostic disable-next-line: redefined-local
        local err, stat = async.uv.fs_fstat(fd)
        assert(not err, err)

        ---@diagnostic disable-next-line: redefined-local
        local err, data = async.uv.fs_read(fd, stat.size, 0)
        assert(not err, err)

        err = async.uv.fs_close(fd)
        assert(not err, err)

        vim.schedule(function()
            local deserialized = vim.fn.json_decode(data)
            M.tabs_data = {}
            for _, item in ipairs(deserialized) do M.tabs_data[item.tabnr] = item.data end

            logging.info("tabs loaded from: " .. filename)
        end)
    end)()
end

function M.load()
    local filename = M.get_file_name()
    load_async(filename)
end

function M.tab_new(filename)
    v.cmd.tablast()
    v.cmd.tabnew(filename)
end

--
-- Commands
--
v.cmd["TabRename"] = M.rename
vim.cmd(":command -nargs=1 -complete=file TabNew lua require'custom_tabs'.tab_new(<args>)")

return M
