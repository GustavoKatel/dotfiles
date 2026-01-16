local cmp = require("cmp")

local lspkind = require("lspkind")

cmp.setup({
	preselect = cmp.PreselectMode.None,
	-- completion = {
	-- 	completeopt = "menuone,noinsert",
	-- },
	window = {
		completion = {
			border = "rounded",
			winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
		},
		documentation = {
			border = "rounded",
			winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
		},
	},
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
		fields = { "abbr", "icon", "kind", "menu" },
		format = lspkind.cmp_format({
			maxwidth = {
				-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				-- can also be a function to dynamically calculate max width such as
				menu = function()
					return math.floor(0.45 * vim.o.columns)
				end,
				-- menu = 50, -- leading text (labelDetails)
				abbr = 50, -- actual suggestion item
			},
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			show_labelDetails = true, -- show labelDetails in menu. Disabled by default

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			before = function(entry, vim_item)
				vim_item.menu = (
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
		}),
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
