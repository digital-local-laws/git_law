angular
  .module 'gitLaw'
  .factory( 'ProposedLaw', ['$resource', ($resource) ->
    return $resource(
      '/api/proposed_laws/:proposedLawId.:format'
      { proposedLawId: "@id", format: 'json', camel: 'true' }
      { save: { method: 'PATCH' },
      create: { method: 'POST',
      url: '/api/codes/:codeId/proposed_laws/:proposedLawId.:format',
      params: { codeId: "@codeId" } },
      codeQuery: { method: 'GET',
      url: '/api/codes/:codeId/proposed_laws/page/:page.:format',
      params: { codeId: "@codeId", page: "@page" },
      isArray: true } } )
  ] )

