json.array! proposed_laws do |proposed_law|
  json.partial! 'proposed_laws/proposed_law', proposed_law: proposed_law
end
