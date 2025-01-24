;; extends

(block_mapping_pair
    key: (flow_node) @_key (#eq? @_key "resources")
    value: [
        (block_node (block_sequence (block_sequence_item
            (flow_node) @filename
        )))
    ]
)

;; vim: set ft=query:
