angular
  .module 'gitLaw'
  .controller 'NavigationCtrl', [ '$scope', '$rootScope', '$http',
  ($scope, $rootScope, $http) ->
    $scope.currentUser = ->
      return $rootScope.currentUser if $rootScope.currentUser
      $scope.checkSession()
    $scope.checkSession = ->
      success = (data) ->
        $rootScope.currentUser = data
      error = () ->
        $rootScope.currentUser = { }
      $http.get('/user_session.json').success(success).error(error)
    $scope.signOut = ->
      console.log "Start"
      success = () ->
        $rootScope.currentUser = { }
      error = () ->
        false
      $http.delete('/user_session.json').success(success).error(error)
      console.log "Finish"
    $scope.checkSession()
  ]
