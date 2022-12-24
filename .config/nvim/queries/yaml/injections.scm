;; extends

;; set highlight to javascript in "actions/github-script" blocks
(
  (block_mapping_pair
    key: (flow_node) @_uses (#eq? @_uses "uses")
    value: (flow_node
           (plain_scalar) @_value (#match? @_value "^actions/github-script.*"))
  )
  (block_mapping_pair)*
  (block_mapping_pair
    key: (flow_node) @_with (#eq? @_with "with")
    value: (block_node
             (block_mapping 
               (block_mapping_pair
                 key: (flow_node) @_script (#eq? @_script "script")
                 value: [
                         (block_node (block_scalar) @javascript (#offset! @javascript 0 1 0 0))
                         (flow_node (double_quote_scalar) @javascript (#offset! @javascript 0 1 0 -1))
                         (flow_node (single_quote_scalar) @javascript (#offset! @javascript 0 1 0 -1))
                         (flow_node (plain_scalar) @javascript (#offset! @javascript 0 0 0 0))
                         ]
                 )))
  )
)


;; same as before, but "uses" come after the "with"
;; i'm sure there's a better way to handle this
(
  (block_mapping_pair
    key: (flow_node) @_with (#eq? @_with "with")
    value: (block_node
             (block_mapping 
               (block_mapping_pair
                 key: (flow_node) @_script (#eq? @_script "script")
                 value: [
                         (block_node (block_scalar) @javascript (#offset! @javascript 0 1 0 0))
                         (flow_node (double_quote_scalar) @javascript (#offset! @javascript 0 1 0 -1))
                         (flow_node (single_quote_scalar) @javascript (#offset! @javascript 0 1 0 -1))
                         (flow_node (plain_scalar) @javascript (#offset! @javascript 0 0 0 0))
                         ]
                 )))
  )
  (block_mapping_pair)*
  (block_mapping_pair
    key: (flow_node) @_uses (#eq? @_uses "uses")
    value: (flow_node
           (plain_scalar) @_value (#match? @_value "^actions/github-script.*"))
  )
)


;; vim: set ft=query:
