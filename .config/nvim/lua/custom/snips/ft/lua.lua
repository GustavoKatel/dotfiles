local ls = require("luasnip")

return {
	ls.parser.parse_snippet("fn", "local function $1($2)\n\t$0\nend"),
}
