-- Inspired by: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/custom/multi_rg.lua
-- But based on the latest live_grep implementation on telescope.nvim
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local conf = require("telescope.config").values
local Path = require("plenary.path")

local vim = vim
local flatten = vim.tbl_flatten
local filter = vim.tbl_filter

local M = {}

local function trim_str(s)
    if s == nil then return "" end

    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local escape_chars = function(string)
    return string.gsub(string, "[%(|%)|\\|%[|%]|%-|%{%}|%?|%+|%*|%^|%$]", {
        ["\\"] = "\\\\",
        ["-"] = "\\-",
        ["("] = "\\(",
        [")"] = "\\)",
        ["["] = "\\[",
        ["]"] = "\\]",
        ["{"] = "\\{",
        ["}"] = "\\}",
        ["?"] = "\\?",
        ["+"] = "\\+",
        ["*"] = "\\*",
        ["^"] = "\\^",
        ["$"] = "\\$"
    })
end
M.escape_chars = escape_chars

M.live_grep_pattern = function(opts)
    local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
    local search_dirs = opts.search_dirs
    local grep_open_files = opts.grep_open_files
    opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()

    opts.debug = opts.debug or false

    local filelist = {}

    if grep_open_files then
        local bufnrs = filter(function(b)
            if 1 ~= vim.fn.buflisted(b) then return false end
            return true
        end, vim.api.nvim_list_bufs())
        if not next(bufnrs) then return end

        for _, bufnr in ipairs(bufnrs) do
            local file = vim.api.nvim_buf_get_name(bufnr)
            table.insert(filelist, Path:new(file):make_relative(opts.cwd))
        end
    elseif search_dirs then
        for i, path in ipairs(search_dirs) do search_dirs[i] = vim.fn.expand(path) end
    end

    local live_grepper = finders.new_job(function(prompt)
        -- TODO: Probably could add some options for smart case and whatever else rg offers.

        if not prompt or prompt == "" then return nil end

        local prompt_split = vim.split(prompt, "|>")

        prompt = escape_chars(prompt_split[1])
        local glob = trim_str(prompt_split[2])

        if #prompt_split > 1 then prompt = trim_str(prompt) end

        local glob_args = {}

        if glob ~= nil and glob ~= "" then
            table.insert(glob_args, "-g")
            table.insert(glob_args, glob)
        end

        local search_list = {}

        if search_dirs then
            table.insert(search_list, search_dirs)
        else
            table.insert(search_list, ".")
        end

        if grep_open_files then search_list = filelist end

        local args = flatten {vimgrep_arguments, glob_args, prompt, search_list}

        if opts.debug then vim.cmd(":echo '" .. table.concat(args, ", ") .. "'") end

        return args
    end, opts.entry_maker or make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

    pickers.new(opts, {
        prompt_title = "Live Grep (pattern: <prompt> |> <glob_pattern>)",
        finder = live_grepper,
        previewer = conf.grep_previewer(opts),
        sorter = conf.generic_sorter(opts)
    }):find()
end

return M
