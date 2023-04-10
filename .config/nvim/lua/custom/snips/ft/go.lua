local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local c = ls.choice_node
local t = ls.text_node
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep

-- part of this is based on https://github.com/tjdevries/config_manager/blob/8f14ab2dd6ba40645af196cc40116b55c0aca3c0/xdg_config/nvim/lua/tj/snips/ft/go.lua

local ts_locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")

local get_node_text = vim.treesitter.get_node_text

vim.treesitter.query.set(
	"go",
	"LuaSnip_Result",
	[[
  [
    (method_declaration result: (_) @id)
    (function_declaration result: (_) @id)
    (func_literal result: (_) @id)
  ]
]]
)

local transform = function(text, info)
	if text == "int" then
		return t("0")
	elseif text == "error" then
		if info then
			info.index = info.index + 1

			return c(info.index, {
				t(string.format('errors.Wrap(%s, "%s")', info.err_name, info.func_name)),
				t(info.err_name),
			})
		else
			return t("err")
		end
	elseif text == "bool" then
		return i(info.index, "false")
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

local function go_result_type(info)
	local cursor_node = ts_utils.get_node_at_cursor()
	local scope = ts_locals.get_scope_tree(cursor_node, 0)

	local function_node
	for _, v in ipairs(scope) do
		if v:type() == "function_declaration" or v:type() == "method_declaration" or v:type() == "func_literal" then
			function_node = v
			break
		end
	end

	local query = vim.treesitter.get_query("go", "LuaSnip_Result")
	for _, node in query:iter_captures(function_node, 0) do
		if handlers[node:type()] then
			return handlers[node:type()](node, info)
		end
	end

	return { t(info.err_name) }
end

local go_ret_vals = function(args)
	local info = { index = 0, err_name = args[1][1], func_name = args[2][1] }
	local nodes = go_result_type(info)
	return sn(nil, nodes)
end

return {
	s(
		"err",
		fmt("if err != nil {{\n\treturn {}\n}}", {
			c(1, {
				t("err"),
				sn(nil, fmt("{}, err", { i(1) })),
			}),
		})
	),

	s(
		"errfn",
		fmt("if {} := {}; {} != nil {{\n\treturn {}\n}}", {
			i(1, "err"),
			i(2, "fn"),
			rep(1), -- repeat variable "err"
			d(3, go_ret_vals, { 1, 2 }),
			--c(2, {

			--t("return err"),
			--sn(nil, fmt("return {}, err", { i(1) })),
			--}),
		})
	),

	s(
		"fn",
		c(1, {
			sn(
				nil,
				fmt("func {}({}) {} {{\n\t{}\n}}", {
					i(1, "fn"),
					i(2),
					c(3, {
						t("error"),
						sn(nil, fmt("({}, error)", { i(1) })),
					}),
					i(4),
				})
			),
			sn(
				nil,
				fmt("func ({} {}) {}({}) {} {{\n\t{}\n}}", {
					i(1, "obj"),
					i(2),
					i(3, "fn"),
					i(4),
					c(5, {
						t("error"),
						sn(nil, fmt("({}, error)", { i(1) })),
					}),
					i(6),
				})
			),
		})
	),
}
