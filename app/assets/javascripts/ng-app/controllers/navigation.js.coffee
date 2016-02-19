angular
  .module 'gitLaw'
  .controller 'NavigationCtrl', [ '$scope', '$auth', '$state',
  (session, $scope, $auth, $state) ->
    $scope.signOut = ->
      $auth.signOut().catch( (resp) ->
        console.log('signout failed') )
  ]
