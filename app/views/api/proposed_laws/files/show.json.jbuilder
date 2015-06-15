json.proposed_law_id proposed_law.id
json.partial! 'working_file', working_file: working_file
json.content unless working_file.directory? || working_file.binary?
json.children if working_file.diretory?
json.ancestors do
  json.array! working_file.ancestors do |ancestor|
    json.partial! 'working_file', working_file: ancestor
  end
end
