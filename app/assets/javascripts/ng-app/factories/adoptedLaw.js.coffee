angular
  .module 'gitLaw'
  .factory( 'AdoptedLaw', ['$resource', ($resource) ->
    return $resource(
      '/api/adopted_laws/:adoptedLawId.:format'
      { adoptedLawId: "@id", format: 'json', camel: 'true' }
      { save: { method: 'PATCH' },
      create: { method: 'POST',
      url: '/api/proposed_laws/:proposedLawId/adopted_law.:format',
      params: { proposedLawId: "@proposedLawId" } },
      jurisdictionQuery: { method: 'GET',
      url: '/api/jurisdictions/:jurisdictionId/adopted_laws/page/:page.:format',
      params: { jurisdictionId: "@jurisdictionId", page: "@page" },
      isArray: true } } )
  ] )
