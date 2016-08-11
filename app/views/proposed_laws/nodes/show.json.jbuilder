json.proposed_law_id proposed_law.id
json.partial! 'node', node: node
json.allowed_child_node_types node.allowed_child_node_types
json.text node.text
json.ancestor_nodes do
  json.array! node.ancestor_nodes do |ancestor|
    json.partial! 'node', node: ancestor
  end
end
