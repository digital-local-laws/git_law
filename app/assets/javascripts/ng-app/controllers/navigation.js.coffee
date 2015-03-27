angular
  .module 'gitLaw'
  .controller 'NavigationCtrl', [ 'session', '$scope',
  (session, $scope) ->
    $scope.currentUser = ->
      session.currentUser()
    $scope.checkSession = ->
      session.checkSession()
    $scope.signOut = ->
      session.signOut()
    $scope.checkSession()
  ]
