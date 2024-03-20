-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = vim.api.nvim_create_augroup("RestNvim", { clear = true }),
-- 	pattern = "http",
-- 	callback = function(event_opts)
-- 		vim.api.nvim_create_user_command("RestNvim", function(opts)
-- 			if not opts or not opts.fargs[1] or opts.fargs[1] == "current" then
-- 				require("rest-nvim").run()
-- 			elseif opts.fargs[1] == "last" then
-- 				require("rest-nvim").last()
-- 			elseif opts.fargs[1] == "preview" then
-- 				require("rest-nvim").preview(true)
-- 			end
-- 		end, {
-- 			nargs = "?",
-- 			desc = "Run RestNvim",
-- 			buffer = event_opts.buffer,
-- 			complete = function()
-- 				-- return completion candidates as a list-like table
-- 				return { "current", "last", "preview" }
-- 			end,
-- 		})
-- 	end,
-- })

return {
	result = {
		behavior = {
			formatters = {
				html = function(body)
					if vim.fn.executable("tidy") == 0 then
						return body, { found = false, name = "tidy" }
					end
					local fmt_body = vim.fn
						.system({
							"tidy",
							"-i",
							"-q",
							"--tidy-mark",
							"no",
							"--show-errors",
							"0",
							"--show-warnings",
							"0",
							"-",
						}, body)
						:gsub("\n$", "")

					return fmt_body, { found = true, name = "tidy" }
				end,
			},
		},
	},
	keybinds = {
		{
			"<leader>rr",
			"<cmd>Rest run<cr>",
			"Run request under the cursor",
		},
		{
			"<leader>rl",
			"<cmd>Rest run last<cr>",
			"Re-run latest request",
		},
	},
}
