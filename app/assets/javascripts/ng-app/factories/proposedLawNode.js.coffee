angular
  .module 'gitLaw'
  .factory( 'ProposedLawNode', ['$resource', ($resource) ->
    return $resource(
      '/api/proposed_laws/:proposedLawId/tree/:tree.:format'
      { 
        proposedLawId: "@proposedLawId"
        tree: "@tree"
        format: 'json'
        camel: 'true'
      }
      { 
        save:
          method: 'PATCH'
        create:
          method: 'POST'
      } )
  ] )

