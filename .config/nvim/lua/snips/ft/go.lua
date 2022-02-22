local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local c = ls.choice_node
local t = ls.text_node
local sn = ls.snippet_node
local i = ls.insert_node

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
		"iferr",
		fmt("if err := {}; err != nil {{\n\t{}\n}}", {
			i(1),
			c(2, {
				t("return err"),
				sn(nil, fmt("return {}, err", { i(1) })),
			}),
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
