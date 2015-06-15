angular
  .module 'gitLaw'
  .factory( 'ProposedLawFile', ['$resource', ($resource) ->
    return $resource(
      '/api/proposed_laws/:proposedLawId/file/:tree.:format'
      {
        proposedLawId: "@proposedLawId"
        tree: "@tree"
        format: 'json'
        camel: 'true'
      }
      {
        query:
          method: 'GET'
          isArray: true
          url: '/api/proposed_laws/:proposedLawId/files/:tree.:format'
        save:
          method: 'PUT'
        create:
          method: 'POST'
      } )
  ] )
