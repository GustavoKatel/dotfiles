local v = require("utils")

v.opt.foldmarker = "#region,#endregion"

-- viml and lua use the default marker
vim.api.nvim_exec([[
augroup custom_fold_marker
  autocmd!
  autocmd FileType vim,viml,lua setlocal foldmarker='{{{,}}}'
augroup END
]], false)

