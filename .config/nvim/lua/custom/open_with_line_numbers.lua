-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
-- 	group = vim.api.nvim_create_augroup("open_with_line_numbers", { clear = true }),
-- 	pattern = { "*#\\(\\d\\+\\)" },
-- 	callback = function(opts)
-- 		P(opts)
-- 	end,
-- })

local M = {}

-- @param link string
function M.github_link_open(link)
	link = string.gsub(link or "", "https://github.com", "")
	P({ link = link or "nil" })
end

return M
