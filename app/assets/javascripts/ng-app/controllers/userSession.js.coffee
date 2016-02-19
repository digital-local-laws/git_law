angular
  .module 'gitLaw'
  .controller( 'UserSessionCtrl', ['$scope', '$state', '$auth', '$rootScope',
  ( $scope, $state, $auth, $rootScope ) ->
    $scope.signIn = (provider) ->
      $auth.authenticate( provider ).
      catch( ( resp ) ->
        Flash.create( 'Login failed.' )
        $state.go 'home' )
    $scope.cancel = ->
      $state.go( 'home' )
    # If the user is already logged in, get us out of here
    # TODO: Is there a better way to work around this issue?
    $auth.validateUser().
    then( ( user ) ->
      $rootScope.currentUser = user
      $rootScope.notifyCurrentUser()
    )
  ])
