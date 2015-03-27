angular
  .module 'gitLaw'
  .factory( 'session', ['$rootScope', '$http', ($rootScope, $http) ->
    { currentUser: ->
        return $rootScope.currentUser if $rootScope.currentUser
        this.checkSession()
      checkSession: ->
        success = (data) ->
          $rootScope.currentUser = data
        error = () ->
          $rootScope.currentUser = { }
        $http.get('/user_session.json').success(success).error(error)
      signOut: ->
        success = () ->
          $rootScope.currentUser = { }
        error = () ->
          false
        $http.delete('/user_session.json').success(success).error(error)
    }
  ] )

