local ls = require("luasnip")
local types = require("luasnip.util.types")

require("luasnip.loaders.from_vscode").lazy_load()

ls.config.set_config({
	-- This tells LuaSnip to remember to keep around the last snippet.
	-- You can jump back into it even if you move outside of the selection
	history = true,

	-- This one is cool cause if you have dynamic snippets, it updates as you type!
	updateevents = "TextChanged,TextChangedI",

	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",

	-- Autosnippets:
	enable_autosnippets = true,

	-- ext_opts = nil,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "<-", "Error" } },
			},
		},
	},
})

local snippets = {}

-- auto load snippets in ft folder
for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom/snips/ft/*.lua", true)) do
	local ft = vim.fn.fnamemodify(ft_path, ":t:r")
	snippets[ft] = loadfile(ft_path)()
	--print(vim.inspect(loadfile(ft_path)()))
end

ls.add_snippets(nil, snippets)
