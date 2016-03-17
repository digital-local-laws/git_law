angular
  .module 'gitlawModels'
  .factory 'User', ($resource) ->
    return $resource(
      '/api/users/:userId.:format'
      { userId: "@id", format: 'json', camel: 'true' }
      {
        save:
          method: 'PATCH'
        create:
          method: 'POST'
      }
    )
