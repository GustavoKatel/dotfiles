local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local c = ls.choice_node
local t = ls.text_node
local sn = ls.snippet_node
local i = ls.insert_node

return {
	ls.parser.parse_snippet("log", "console.log($1)"),

	s(
		"import",
		fmt("import {} from '{}'", {
			c(1, {
				sn(nil, { i(1) }),
				sn(nil, { t({ "{" }), i(1), t("}") }),
			}),
			i(2),
		})
	),

	s(
		"fn",
		c(1, {
			sn(nil, fmt("({}) => {{ {} }}", { i(1), i(2) })),
			sn(nil, fmt("({}): Promise<{}> => {{ {} }}", { i(1), i(2), i(3) })),
			sn(nil, fmt("function({}) {{ {} }}", { i(1), i(2) })),
			sn(nil, fmt("function({}): Promise<{}> {{ {} }}", { i(1), i(2), i(3) })),
		})
	),

	s(
		"asyncfn",
		c(1, {
			sn(nil, fmt("async ({}) => {{ {} }}", { i(1), i(2) })),
			sn(nil, fmt("async ({}): Promise<{}> => {{ {} }}", { i(1), i(2), i(3) })),
			sn(nil, fmt("async function({}) {{ {} }}", { i(1), i(2) })),
			sn(nil, fmt("async function({}): Promise<{}> {{ {} }}", { i(1), i(2), i(3) })),
		})
	),

	s(
		"it",
		c(1, {
			sn(nil, fmt('it("{}", async () => {{\n\t{}\n}})', { i(1), i(2) })),
			sn(nil, fmt('it("{}", () => {{\n\t{}\n}})', { i(1), i(2) })),
		})
	),

	ls.parser.parse_snippet("describe", 'describe("$1", () => {\n\t$2\n})'),
}
