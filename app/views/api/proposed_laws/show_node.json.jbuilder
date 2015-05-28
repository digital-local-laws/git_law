json.proposed_law_id proposed_law.id
json.file_name working_file.file_name
json.base_path working_file.base_path
json.tree working_file.path_in_repo
json.type working_file.type
json.metadata working_file.metadata
json.structure working_file.structure
json.child_structure working_file.child_structure
if working_file.content.is_a? Array
  json.content do
    json.array! working_file.content do |entry|
      json.file_name entry.file_name
      json.tree entry.path_in_repo
      json.type entry.type
      json.metadata entry.metadata
    end
  end
# TODO: What about binary files?
else
  json.content working_file.content
end
json.ancestors do
  json.array! working_file.ancestors do |ancestor|
    json.file_name ancestor.file_name
    json.tree ancestor.path_in_repo
    json.type ancestor.type
    json.metadata ancestor.metadata
  end
end
