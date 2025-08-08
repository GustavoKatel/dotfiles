-- Adapter from https://cj.rs/blog/luasnip-and-treesitter-for-smarter-snippets/
local ls = require("luasnip")
local f = ls.function_node
local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local sn = ls.snippet_node
local snippet_from_nodes = ls.sn

local get_node_text = vim.treesitter.get_node_text

-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
local function same(index)
	return f(function(args)
		return args[1]
	end, { index })
end

-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
vim.treesitter.query.set(
	"go",
	"LuaSnip_Result",
	[[ [
    (method_declaration result: (_) @id)
    (function_declaration result: (_) @id)
    (func_literal result: (_) @id)
  ] ]]
)

-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
local transform = function(text, info)
	if text == "int" or text == "int8" or text == "int16" or text == "int32" or text == "int64" then
		return t("0")
	elseif text == "error" then
		if info then
			info.index = info.index + 1

			return c(info.index, {
				sn(nil, i(1, info.err_name)),
				sn(nil, fmt('fmt.Errorf("{}: %v", {})', { i(1), i(2, info.err_name) })),
				-- Be cautious with wrapping, it makes the error part of the API of the
				-- function, see https://go.dev/blog/go1.13-errors#whether-to-wrap
				sn(nil, fmt('fmt.Errorf("{}: %w", {})', { i(1), i(2, info.err_name) })),
			})
		else
			return t("err")
		end
	elseif text == "bool" then
		return t("false")
	elseif text == "string" then
		return t('""')
	elseif string.find(text, "*", 1, true) then
		return t("nil")
	end

	return t(text)
end

local handlers = {
	["parameter_list"] = function(node, info)
		local result = {}

		local count = node:named_child_count()
		for idx = 0, count - 1 do
			table.insert(result, transform(get_node_text(node:named_child(idx), 0), info))
			if idx ~= count - 1 then
				table.insert(result, t({ ", " }))
			end
		end

		return result
	end,

	["type_identifier"] = function(node, info)
		local text = get_node_text(node, 0)
		return { transform(text, info) }
	end,
}

-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
local function go_result_type(info)
	local query = vim.treesitter.query.get("go", "LuaSnip_Result")

	local root = vim.treesitter.get_parser(0, "go"):parse(true)[1]:root()

	local cursor = vim.api.nvim_win_get_cursor(0)

	local start_row = cursor[1] - 1
	local end_row = start_row + 1

	for _, match, metadata in query:iter_matches(root, 0, start_row, end_row, { all = true }) do
		for id, nodes in ipairs(match) do
			local name = query.captures[id]

			for _, node in ipairs(nodes) do
				local mt = metadata[id] -- Node level metadata
				if handlers[node:type()] then
					return handlers[node:type()](node, info)
				end
			end
		end
	end

	return { t("") }
end

-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
local go_ret_vals = function(args)
	return snippet_from_nodes(
		nil,
		go_result_type({
			index = 0,
			err_name = args[1][1],
			-- function_name = args[2][1],
		})
	)
end

return {
	-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
	s("err", {
		t({ "if " }),
		i(1, { "err" }),
		t({ " != nil {", "\treturn " }),
		d(2, go_ret_vals, { 1 }),
		t({ "", "}" }),
		i(0),
	}),
}
