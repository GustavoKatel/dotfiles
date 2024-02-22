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
                         (block_node (block_scalar) @injection.content (#offset! @injection.content 0 1 0 0) (#set! injection.language "javascript") (#set! injection.include-children))
                         (flow_node (double_quote_scalar) @injection.content (#offset! @injection.content 0 1 0 -1) (#set! injection.language "javascript") (#set! injection.include-children))
                         (flow_node (single_quote_scalar) @injection.content (#offset! @injection.content 0 1 0 -1) (#set! injection.language "javascript") (#set! injection.include-children))
                         (flow_node (plain_scalar) @injection.content (#offset! @injection.content 0 0 0 0) (#set! injection.language "javascript") (#set! injection.include-children))
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
                         (block_node (block_scalar) @injection.content (#offset! @injection.content 0 1 0 0) (#set! injection.language "javascript") (#set! injection.include-children))
                         (flow_node (double_quote_scalar) @injection.content (#offset! @injection.content 0 1 0 -1) (#set! injection.language "javascript") (#set! injection.include-children))
                         (flow_node (single_quote_scalar) @injection.content (#offset! @injection.content 0 1 0 -1) (#set! injection.language "javascript") (#set! injection.include-children))
                         (flow_node (plain_scalar) @injection.content (#offset! @injection.content 0 0 0 0) (#set! injection.language "javascript") (#set! injection.include-children))
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


;; Tasksfile.[yaml,yml] inject bash syntax
(block_mapping_pair
    key: (flow_node) @_tasks (#eq? @_tasks "tasks")
    value: (block_node
        (block_mapping
          (block_mapping_pair
            key: (flow_node
                (plain_scalar
                  (string_scalar) @tasks.name
            ))
            value: (block_node
                     (block_mapping
                       (block_mapping_pair
                         key: (flow_node) @_cmds (#eq? @_cmds "cmds")
                         value: (
                            (block_node
                              (block_sequence
                                (block_sequence_item
                                  (flow_node) @injection.content (#set! injection.language "bash") (#set! injection.include-children)
                                  )
                                )
                              )

                        ) 
                         )
                       )
                    ) 
            )
    ))
  )

;; vim: set ft=query:
