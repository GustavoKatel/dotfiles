
lua <<EOF

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    use_languagetree = false, -- Use this to enable language injection (this is very unstable)
    custom_captures = {
    },
  },
}

EOF
