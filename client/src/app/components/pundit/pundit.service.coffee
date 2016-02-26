angular.module 'client'
  .factory 'pundit', ( $auth, $log, $rootScope ) ->
    fail = () ->
      { }
    # Test if user has staff-level privilege
    staff = ( user ) ->
      user.admin || user.staff
    # Test if user has admin-level privilege
    admin = ( user ) ->
      user.admin
    # Test if user is logged in
    check = ( test, callback ) ->
      $auth.validateUser()
        .then( test )
        .then( callback )
    punditPolicies =
      jurisdiction: ( user ) ->
        {
          create: staff user
          update: staff user
          destroy: admin user
        }
    pundit = ( policy, callback ) ->
      check punditPolicies[ policy ], callback
    return pundit
