local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = { ["<CR>"] = cmp.mapping.confirm({ select = true }) },
	sources = { { name = "nvim_lsp" }, { name = "nvim_lua" }, { name = "path" }, { name = "buffer" }, { name = "emoji" } },
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
				})[entry.source.name]
			return vim_item
		end,
	},
})
