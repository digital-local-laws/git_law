json.partial! 'proposed_laws/proposed_law', proposed_law: proposed_law
json.jurisdiction do
  json.partial! 'jurisdictions/jurisdiction', jurisdiction: proposed_law.jurisdiction
end
json.working_repo_created proposed_law.working_repo_created
