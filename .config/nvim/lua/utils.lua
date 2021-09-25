-- based on https://github.com/davysson/dotfiles/blob/master/nvim/utils.lua
local v = {}

unpack = unpack or table.unpack

v.unpack = unpack

-- Some util functions
math.randomseed(os.time())

local function clean_fn_name(name)
	if not name or name == "" then
		return ""
	end

	local cleaned = string.gsub(name, "%s+", "")
	return cleaned
end

local function make_global_fn(fn, key)
	local prefix = "_fn_"

	key = clean_fn_name(key)

	local fn_name = prefix .. key .. math.random(1000000)
	while true do
		if _G[fn_name] == nil then
			break
		end
		fn_name = prefix .. key .. math.random(1000000)
	end
	_G[fn_name] = fn
	return fn_name
end

local function table_to_str(array, split)
	local str = ""
	for _, value in ipairs(array) do
		str = str .. value .. split
	end
	return str:sub(1, #str - #split)
end

-- Wrapper for vim options

local function has_global_opt(key)
	local status, result = pcall(vim.api.nvim_get_option, key)
	return status
end

local function has_buffer_opt(key)
	local status, result = pcall(vim.api.nvim_buf_get_option, 0, key)
	return status
end

local function has_window_opt(key)
	local status, result = pcall(vim.api.nvim_win_get_option, 0, key)
	return status
end

-- Options
v.o = {}
v.opt = v.o
v.options = v.o

local __opt_index = function(table, key)
	if has_global_opt(key) then
		return vim.o[key]
	elseif has_buffer_opt(key) then
		return vim.bo[key]
	elseif has_window_opt(key) then
		return vim.wo[key]
	end

	error(string.format("Invalid option name '%s'\n", key))
end

local __opt_newindex = function(table, key, value)
	if type(value) == "table" then
		value = table_to_str(value, ",")
	end

	local found_option = false
	if has_global_opt(key) then
		vim.o[key] = value
		found_option = true
	end

	if has_buffer_opt(key) then
		vim.bo[key] = value
		found_option = true
	end

	if has_window_opt(key) then
		vim.wo[key] = value
		found_option = true
	end

	assert(found_option, string.format("Invalid option name '%s'", key))
end

setmetatable(v.opt, { __index = __opt_index, __newindex = __opt_newindex })

-- Commands
v.c = {}
v.cmd = v.c
v.commands = v.c

local __cmd_index = function(table, key)
	local t = {}
	setmetatable(t, {
		__tostring = function()
			return key
		end,
		__call = function(self, ...)
			local args = table_to_str({ ... }, " ")
			vim.cmd(":" .. key .. " " .. args)
		end,
	})
	return t
end

local __cmd_newindex = function(table, key, fn)
	local nargs = debug.getinfo(fn).nparams
	if nargs > 1 then
		nargs = "*"
	end
	local fn_name = make_global_fn(fn, key)
	vim.cmd(":command -nargs=" .. nargs .. " " .. key .. " call v:lua." .. fn_name .. "(<f-args>)")
end

setmetatable(v.cmd, { __index = __cmd_index, __newindex = __cmd_newindex })

-- Variables
v.v = {}
v.var = v.v
v.variables = v.v

v.v.g = {}
local __var_g_index = function(table, key)
	return vim.g[key]
end

local __var_g_newindex = function(table, key, value)
	vim.g[key] = value
end

v.v.b = {}
local __var_b_index = function(table, key)
	return vim.b[key]
end

local __var_b_newindex = function(table, key, value)
	vim.b[key] = value
end

v.v.w = {}
local __var_w_index = function(table, key)
	return vim.w[key]
end

local __var_w_newindex = function(table, key, value)
	vim.w[key] = value
end

v.v.t = {}
local __var_t_index = function(table, key)
	return vim.t[key]
end

local __var_t_newindex = function(table, key, value)
	vim.t[key] = value
end

v.v.v = {}
local __var_v_index = function(table, key)
	return vim.v[key]
end

local __var_v_newindex = function(table, key, value)
	vim.v[key] = value
end

local __var_index = function(table, key)
	return v.g[key]
end

local __var_newindex = function(table, key, value)
	v.v.g[key] = value
end

setmetatable(v.v.g, { __index = __var_g_index, __newindex = __var_g_newindex })
setmetatable(v.v.b, { __index = __var_b_index, __newindex = __var_b_newindex })
setmetatable(v.v.w, { __index = __var_w_index, __newindex = __var_w_newindex })
setmetatable(v.v.t, { __index = __var_t_index, __newindex = __var_t_newindex })
setmetatable(v.v.v, { __index = __var_v_index, __newindex = __var_v_newindex })
setmetatable(v.v, { __index = __var_index, __newindex = __var_newindex })

-- Autocmd
v.autocmd = function(events, pattern, cmd)
	if type(events) == "table" then
		events = table_to_str(events, ",")
	end

	if type(cmd) == "string" then
		vim.cmd(":autocmd " .. events .. " " .. pattern .. " " .. cmd)
	elseif type(cmd) == "table" then
		vim.cmd(":autocmd " .. events .. " " .. pattern .. " " .. tostring(cmd))
	else
		local fn_name = make_global_fn(cmd)
		vim.cmd(":autocmd " .. events .. " " .. pattern .. " call v:lua." .. fn_name .. "()")
	end
end

-- Functions
v.f = {}
v.fn = v.f
v.functions = v.f

local __fn_index = function(table, key)
	return vim.fn[key]
end

local __fn_newindex = function(table, key, fn)
	local wrapper = function(args)
		return fn(unpack(args))
	end
	local fn_name = make_global_fn(wrapper, key)
	vim.cmd(":function " .. key .. "(...)\ncall v:lua." .. fn_name .. "(a:000)\n:endfunction")
end

setmetatable(v.f, { __index = __fn_index, __newindex = __fn_newindex })

-- Keymaps
local mappings = {
	"map",
	"noremap",
	"unmap",
	"nmap",
	"nnoremap",
	"nunmap",
	"vmap",
	"vnoremap",
	"vunmap",
	"smap",
	"snoremap",
	"sunmap",
	"xmap",
	"xnoremap",
	"xunmap",
	"cmap",
	"cnoremap",
	"cunmap",
	"omap",
	"onoremap",
	"ounmap",
	"imap",
	"inoremap",
	"iunmap",
	"tmap",
	"tnoremap",
	"tunmap",
}

for _, map in ipairs(mappings) do
	v[map] = function(
		key,
		cmd, --[[optional]]
		no_esc
	)
		if type(key) == "table" then
			key = table_to_str(key, "")
		end

		if type(cmd) == "string" then
			vim.cmd(":" .. map .. " " .. key .. " " .. cmd)
		elseif type(cmd) == "table" then
			vim.cmd(":" .. map .. " " .. key .. " :" .. tostring(cmd) .. "<CR>")
		else
			local fn_name = make_global_fn(cmd)
			local esc = "<ESC>"

			if no_esc then
				esc = ""
			end

			vim.cmd(":" .. map .. " " .. key .. " " .. esc .. ":call v:lua." .. fn_name .. "()<CR>")
		end
	end
end

return v
