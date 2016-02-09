json.id adopted_law.id
json.created_at adopted_law.created_at
json.updated_at adopted_law.updated_at
json.proposed_law do
  json.partial! 'api/proposed_laws/proposed_law', proposed_law: adopted_law.proposed_law
end
json.jurisdiction do
  json.partial! 'api/jurisdictions/jurisdiction', jurisdiction: adopted_law.proposed_law.jurisdiction
end
