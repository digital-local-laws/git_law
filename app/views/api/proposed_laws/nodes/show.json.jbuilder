json.proposed_law_id proposed_law.id
json.partial! 'node', node: node
json.allowed_child_node_types node.allowed_child_node_types
json.text_file_tree node.node_type["text"] ? node.text_file.tree : false
json.ancestor_nodes do
  json.array! node.ancestor_nodes do |ancestor|
    json.partial! 'node', node: ancestor
  end
end
