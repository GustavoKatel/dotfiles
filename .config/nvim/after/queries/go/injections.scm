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

;; ExecContext
function: (selector_expression
  operand: (identifier)
  field: (field_identifier) @method (#eq? @method "ExecContext"))
arguments: (argument_list
  (identifier)
  (raw_string_literal
    (raw_string_literal_content) @injection.content (#set! injection.language "sql"))
)
;; Exec
function: (selector_expression
  operand: (identifier)
  field: (field_identifier) @method (#eq? @method "Exec"))
arguments: (argument_list
  (raw_string_literal
    (raw_string_literal_content) @injection.content (#set! injection.language "sql"))
)

;; QueryContext
function: (selector_expression
  operand: (call_expression
    function: (selector_expression
      operand: (identifier)
      field: (field_identifier) @method (#eq? @method "QueryContext"))
    arguments: (argument_list
      (identifier)
      (raw_string_literal
        (raw_string_literal_content) @injection.content (#set! injection.language "sql"))))
)
;; Query
function: (selector_expression
  operand: (call_expression
    function: (selector_expression
      operand: (identifier)
      field: (field_identifier) @method (#eq? @method "Query"))
    arguments: (argument_list
      (raw_string_literal
        (raw_string_literal_content) @injection.content (#set! injection.language "sql"))))
)

;; QueryRowContext
function: (selector_expression
  operand: (call_expression
    function: (selector_expression
      operand: (identifier)
      field: (field_identifier) @method (#eq? @method "QueryRowContext"))
    arguments: (argument_list
      (identifier)
      (raw_string_literal
        (raw_string_literal_content) @injection.content (#set! injection.language "sql"))))
)
;; QueryRow
function: (selector_expression
  operand: (call_expression
    function: (selector_expression
      operand: (identifier)
      field: (field_identifier) @method (#eq? @method "QueryRow"))
    arguments: (argument_list
      (raw_string_literal
        (raw_string_literal_content) @injection.content (#set! injection.language "sql"))))
)

;; vim: set ft=query:
