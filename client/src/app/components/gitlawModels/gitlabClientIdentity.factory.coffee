angular.module 'gitlawModels'
  .factory 'GitlabClientIdentity', ($resource) ->
    return $resource(
      '/api/gitlab_client_identities/:gitlabClientIdentityId.:format'
      { gitlabClientIdentityId: "@id", format: 'json', camel: 'true' }
      {
        save: { method: 'PATCH' }
        # Complete token request and record token
        create: {
          method: 'POST'
          url: '/api/gitlab_client_identity_requests/:gitlabClientIdentityRequestId/gitlab_client_identities.:format'
          params: { gitlabClientIdentityRequestId: "@gitlabClientIdentityRequestId" }
        }
        userQuery: {
          method: 'GET'
          url: '/api/users/:userId/gitlab_client_identities/page/:page.:format'
          params: { userId: "@userId", page: "@page" }
          isArray: true
        }
      } )
