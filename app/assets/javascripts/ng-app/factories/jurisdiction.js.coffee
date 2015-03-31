angular
  .module 'gitLaw'
  .factory( 'Jurisdiction', ['$resource', ($resource) ->
    return $resource(
      '/api/jurisdictions/:jurisdictionId.:format'
      { jurisdictionId: "@id", format: 'json', camel: 'true' }
      { save: { method: 'PATCH' }, create: { method: 'POST' } } )
  ] )

