;; extends

((comment) @filename (#lua-match? @filename "^//go:embed%s+.*$") (#gsub! @filename "//go:embed (.*)" "%1"))

;; vim: set ft=query:
