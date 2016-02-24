angular.module 'client'
  .run ( $log, $rootScope, $auth, $state, Flash ) ->
    'ngInject'
    # Check on page load whether user is logged in
    $auth.validateUser().then ( user ) ->
      $rootScope.currentUser = user
    # Notify user that he or she is logged in
    $rootScope.notifyCurrentUser = () ->
      Flash.create( 'info', 'You logged in as ' +
        $rootScope.currentUser.name + '.' )
      $state.go 'home'
    # Record user information on login
    $rootScope.$on 'auth:login-success', (ev, user) ->
      $rootScope.currentUser = user
      $rootScope.notifyCurrentUser()
    # Purge user information on logout
    $rootScope.$on 'auth:logout-success', ->
      $rootScope.currentUser = false
      Flash.create( 'info', 'You logged out.' )
      $state.go 'home'
    # TODO: eliminate this?
    # Mark end of runBlock for debug purposes
    # $log.debug 'runBlock end'
