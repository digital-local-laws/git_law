angular.module 'gitlawModels'
  .factory 'ProposedLawNode', ($resource) ->
    return $resource(
      '/api/proposed_laws/:proposedLawId/node/:treeBase.:format'
      {
        proposedLawId: "@proposedLawId"
        treeBase: "@treeBase"
        format: 'json'
        camel: 'true'
      }
      {
        query:
          method: 'GET'
          isArray: true
          url: '/api/proposed_laws/:proposedLawId/nodes/:treeBase.:format'
        save:
          method: 'PATCH'
        create:
          method: 'POST'
      } )
