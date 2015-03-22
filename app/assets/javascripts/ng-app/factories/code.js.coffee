angular
  .module 'gitLaw'
  .factory( 'Code', ['$resource', ($resource) ->
    return $resource(
      '/api/codes/:codeId.:format'
      { codeId: "@id", format: 'json', camel: 'true' }
      { save: { method: 'PATCH' }, create: { method: 'POST' } } )
  ] )

