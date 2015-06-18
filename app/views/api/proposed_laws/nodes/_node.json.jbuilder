json.partial! 'api/proposed_laws/files/working_file', locals: { working_file: node }
json.tree_base node.tree_base
json.attributes node.attributes
json.child_nodes_allowed node.child_node_structure.length > 0
json.node_type node.node_type
