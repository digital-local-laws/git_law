json.array! nodes do |node|
  json.partial! 'node', node: node
end
