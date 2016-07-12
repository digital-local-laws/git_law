angular.module 'gitlawModels'
  .factory 'GitlabClientIdentityRequest', ($resource) ->
    return $resource(
      '/api/gitlab_client_identity_requests/:gitlabClientIdentityRequestId.:format'
      { gitlabClientIdentityRequestId: "@id", format: 'json', camel: 'true' }
      {
        save: { method: 'PATCH' }
        # Complete token request and record token
        create: {
          method: 'POST'
          url: '/api/users/:userId/gitlab_client_identity_requests.:format'
          params: { userId: "@userId" }
        }
        userQuery: {
          method: 'GET'
          url: '/api/users/:userId/gitlab_client_identities/page/:page.:format'
          params: { userId: "@userId", page: "@page" }
          isArray: true
        }
      } )
