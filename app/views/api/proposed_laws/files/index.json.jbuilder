json.array! working_file.children do |child|
  json.partial! 'working_file', working_file: child
end
