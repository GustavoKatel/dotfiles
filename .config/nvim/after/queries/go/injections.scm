;; extends

(_
  name: (identifier)
  ((comment) 
        @injection.language 
        (#gsub! @injection.language "//%s*(.*)%s*" "%1")
        (#gsub! @injection.language "/%*%s*(.*)%s*%*/" "%1")
  )
  value: (expression_list
    [
     (interpreted_string_literal (interpreted_string_literal_content) @injection.content)
     (raw_string_literal (raw_string_literal_content) @injection.content)
     ]
  )
)

(
  ((comment) 
        @injection.language 
        (#gsub! @injection.language "//%s*(.*)%s*" "%1")
        (#gsub! @injection.language "/%*%s*(.*)%s*%*/" "%1")
  )
  [
     (interpreted_string_literal (interpreted_string_literal_content) @injection.content)
     (raw_string_literal (raw_string_literal_content) @injection.content)
     ]
 )

;; vim: set ft=query:
