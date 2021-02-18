require'nvim-treesitter.configs'.setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {"rust", "go", "lua", "json", "python", "yaml", "bash", "css", "javascript", "typescript", "tsx", "html"}, 
    highlight = {
        enable = true,
        use_languagetree = false, -- Use this to enable language injection (this is very unstable)
        custom_captures = {
    },
  },
}

