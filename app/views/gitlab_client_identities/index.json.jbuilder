json.array! gitlab_client_identities do |gitlab_client_identity|
  json.partial! 'gitlab_client_identities/gitlab_client_identity', gitlab_client_identity: gitlab_client_identity
end
