local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Char-0xff>aspace"] = cmp.mapping.complete(), -- show completion suggestions
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
		["<PageUp>"] = cmp.mapping.scroll_docs(-4),
		["<PageDown>"] = cmp.mapping.scroll_docs(4),
	}),
	sources = {
		{
			name = "nvim_lsp",
		},
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "luasnip" },
		{
			name = "buffer",
		},
		{ name = "emoji" },
	},
	formatting = {
		format = function(entry, vim_item)
			local kind = vim_item.kind or ""

			vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

			-- set a name for each source
			vim_item.menu = kind
				.. (
					({
						nvim_lsp = "[LSP]",
						nvim_lua = "[Lua]",
						path = "[Path]",
						buffer = "[Buffer]",
						emoji = "[Emoji]",
						luasnip = "[Snip]",
						cmdline = "[CMD]",
						["vim-dadbod-completion"] = "[DB]",
					})[entry.source.name] or string.format("[%s]", entry.source.name)
				)
			return vim_item
		end,
	},
	window = {
		documentation = cmp.config.window.bordered(),
		completion = cmp.config.window.bordered(),
	},
})

-- Setup up vim-dadbod
cmp.setup.filetype({ "sql" }, {
	sources = {
		{ name = "vim-dadbod-completion" },
		{ name = "buffer" },
	},
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

vim.keymap.set("c", "<Tab>", function()
	if cmp.visible() then
		cmp.select_next_item()
	else
		cmp.complete()
		cmp.select_next_item()
	end
end)

vim.keymap.set("c", "<S-Tab>", function()
	if cmp.visible() then
		cmp.select_prev_item()
	else
		cmp.complete()
		cmp.select_prev_item()
	end
end)
cmp.setup.cmdline(":", {
	completion = { autocomplete = false },
	mapping = cmp.mapping.preset.cmdline({
		["<Tab>"] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
