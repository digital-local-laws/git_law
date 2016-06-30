json.id adopted_law.id
json.jurisdiction_id adopted_law.jurisdiction_id
json.proposed_law_id adopted_law.proposed_law_id
json.year_adopted adopted_law.year_adopted
json.number_in_year adopted_law.number_in_year
json.executive_action adopted_law.executive_action
json.executive_action_on adopted_law.executive_action_on
json.referendum_required adopted_law.referendum_required
json.referendum_type adopted_law.referendum_type
json.election_type adopted_law.election_type
json.referendum_date adopted_law.referendum_type
json.created_at adopted_law.created_at
json.updated_at adopted_law.updated_at
json.proposed_law do
  json.partial! 'proposed_laws/proposed_law',
    proposed_law: adopted_law.proposed_law
end
