json.proposed_law_id proposed_law.id
json.partial! 'node', node: node
json.node_type node.node_type
json.allowed_child_node_types node.allowed_child_node_types
json.text_file_tree node.text_file.exists? ? node.text_file.tree : false
json.ancestor_nodes do
  json.array! node.ancestor_nodes do |ancestor|
    json.partial! 'node', node: ancestor
  end
end
