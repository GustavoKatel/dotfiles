;; extends

(comment) @embed_comment (#match? @embed_comment "^go:embed\s.*") (#offset! @embed_comment 0 0) (#gsub! @embed_comment "//go:embed (.*)" "%1")

;; vim: set ft=query:
