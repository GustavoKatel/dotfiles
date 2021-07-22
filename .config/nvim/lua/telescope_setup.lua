local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<c-s>"] = actions.send_to_qflist,
      },
    },
    --layout_config = { width_padding = 130, height_padding = 15 }
    layout_config = {
      horizontal = {
        width = 230,
        height = 60
      },
    }
  }
}
