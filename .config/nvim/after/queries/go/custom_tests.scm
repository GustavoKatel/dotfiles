;; extends

(method_declaration
  name: (field_identifier) @test_parent_name
  body: (
    (block 
      (statement_list
       (expression_statement
         (call_expression
           function: (selector_expression
                       operand: (identifier) @_sub_test_operand (#match? @_sub_test_operand "^[st].*")
                       field: (field_identifier) @_sub_test_method (#match? @_sub_test_method "^Run.*")
                       )
           arguments: (
                       ( argument_list 
                         (interpreted_string_literal
                           (interpreted_string_literal_content) @test_name
                           )
                         )
                       )
           ) @test_func
       )
      )
)
))

(function_declaration
  name: (identifier) @test_name (#match? @test_name "^Test.*")
  body: (_) @test_func
)

;; vim: set ft=query:
