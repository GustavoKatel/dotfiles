local null_ls = require("null-ls")

local goembed_filename_codeaction = {
	method = null_ls.methods.CODE_ACTION,
	filetypes = { "go" },
	generator = {
		fn = function(params)
			local bufnr = params.bufnr
			local start_row = params.lsp_params.range.start.line
			local end_row = params.lsp_params.range["end"].line+1

			local query = vim.treesitter.query.get("go", "embed_comment")
			assert(query, "Query 'embed_comment' not found")

			local root = vim.treesitter.get_parser(bufnr, "go"):parse(true)[1]:root()

			local actions = {}

			for id, node, metadata, match in query:iter_captures(root, bufnr, start_row, end_row) do
				local text = vim.treesitter.get_node_text(node,bufnr, { metadata = metadata })

				if string.match(text, "^//go:embed .*") then
					local filename = string.gsub(text, "//go:embed (.*)", "%1")

					table.insert(actions, {
						title = string.format("Go: open embed filename [%s]", filename),
						action = function()
							local source_filename = vim.api.nvim_buf_get_name(bufnr)
							local filepath = vim.fn.fnamemodify(source_filename, ":h")
							vim.api.nvim_command(string.format("e %s/%s", filepath, filename))
						end,
					})
				end
			end

			return actions
		end,
	},
}
null_ls.register(goembed_filename_codeaction)
