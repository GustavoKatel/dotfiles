local v = require("utils")

v.v["test#strategy"] = "floaterm"

-- vim.cmd([[
-- let g:test#rust#cargotest#test_patterns = {
-- \ 'test': ['\v(#\[%(tokio::|rs)?test)','\v(#\[(.+)?test)'],
-- \ 'namespace': ['\vmod (tests?)']
-- \ }
-- ]])
