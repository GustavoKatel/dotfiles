;; extends

(
 ; set highlight to query
 (function_call
     name: (_) @_fn_name
     (#eq? @_fn_name "vim.treesitter.query.set")
     arguments: (_ 
         (_)
         (_)
         (string) @query
         (#offset! @query 0 2 0 -2)
     )
 )

)

;; vim: set ft=query:
