local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
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
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "emoji" },
	},
	formatting = {
		format = function(entry, vim_item)
			local kind = ""
			if vim.g.gonvim_running == 1 and vim_item.kind then
				kind = "(" .. vim_item.kind .. ")" .. " "
			end

			vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

			-- set a name for each source
			vim_item.menu = kind
				.. ({
					nvim_lsp = "[LSP]",
					nvim_lua = "[Lua]",
					path = "[Path]",
					buffer = "[Buffer]",
					emoji = "[Emoji]",
					luasnip = "[Snip]",
				})[entry.source.name]
			return vim_item
		end,
	},
	window = {

		documentation = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
	},
})
