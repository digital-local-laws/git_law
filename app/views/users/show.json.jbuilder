json.partial! 'users/user', user: user
json.jurisdiction_memberships user.jurisdiction_memberships.
includes(:jurisdiction) do |membership|
  json.id membership.id
  json.jurisdiction do
    json.partial! 'jurisdictions/jurisdiction', jurisdiction: membership.jurisdiction
  end
  json.propose membership.propose
  json.adopt membership.adopt
end
