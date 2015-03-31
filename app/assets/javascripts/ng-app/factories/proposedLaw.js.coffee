angular
  .module 'gitLaw'
  .factory( 'ProposedLaw', ['$resource', ($resource) ->
    return $resource(
      '/api/proposed_laws/:proposedLawId.:format'
      { proposedLawId: "@id", format: 'json', camel: 'true' }
      { save: { method: 'PATCH' },
      create: { method: 'POST',
      url: '/api/jurisdictions/:jurisdictionId/proposed_laws/:proposedLawId.:format',
      params: { jurisdictionId: "@jurisdictionId" } },
      jurisdictionQuery: { method: 'GET',
      url: '/api/jurisdictions/:jurisdictionId/proposed_laws/page/:page.:format',
      params: { jurisdictionId: "@jurisdictionId", page: "@page" },
      isArray: true } } )
  ] )

