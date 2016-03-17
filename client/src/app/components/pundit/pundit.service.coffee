angular.module 'client'
  .factory 'pundit', ( $auth, $log ) ->
    fail = () ->
      false
    # Test if user has staff-level privilege
    staff = ( user ) ->
      user.admin || user.staff
    # Test if user has admin-level privilege
    admin = ( user ) ->
      user.admin
    copy = (obj) ->
      newObj = {}
      for key, value of obj
        newObj[ key ] = value
      return newObj
    punditPolicies =
      global:
        adminMenu: (context) ->
          staff context.user
      user:
        create: (context) ->
          staff context.user
        update: (context) ->
          staff context.user
        destroy: (context) ->
          admin context.user
      jurisdiction:
        create: (context) ->
          staff context.user
        update: (context) ->
          staff context.user
        destroy: (context) ->
          admin context.user
      proposedLaw:
        own: ( context ) ->
          context.user.permissions.jurisdiction.propose
            .indexOf( context.proposedLaw.jurisdictionId ) >= 0 &&
          context.user.id == context.proposedLaw.userId
        create: (context) ->
          context.user.permissions.jurisdiction.propose
            .indexOf( context.jurisdictionId ) >= 0
        update: (context) ->
          punditPolicies.proposedLaw.own context
        destroy: (context) ->
          punditPolicies.proposedLaw.own context
        adopt: (context) ->
          context.user.permissions.jurisdiction.adopt
            .indexOf( context.proposedLaw.jurisdictionId ) >= 0
    # Checks whether user has one or more permissions under a policy
    # @param [object] context Contextual parameters to pass to policy (must specify policy)
    # @param [function] callback Callback which will receive policy result
    ( context, callback ) ->
      throw new Exception 'No policy specified' unless context.policy
      $auth.validateUser()
        .then ( user ) ->
          userContext = copy( context )
          userContext.user = user
          if context.action
            results = punditPolicies[ context.policy ][ context.action ] userContext
          else
            results = {}
            for action, test of punditPolicies[ context.policy ]
              results[ action ] = test userContext
          return results
        .then( callback )
