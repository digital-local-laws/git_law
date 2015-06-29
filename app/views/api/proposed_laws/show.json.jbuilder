json.id proposed_law.id
json.title proposed_law.title
json.created_at proposed_law.created_at
json.updated_at proposed_law.updated_at
json.jurisdiction do
  json.partial! 'api/jurisdictions/jurisdiction', jurisdiction: proposed_law.jurisdiction
end
json.working_repo_created proposed_law.working_repo_created
