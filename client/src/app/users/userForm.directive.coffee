angular.module 'client'
  .directive 'userForm', () ->
    {
      scope: {}
      templateUrl: 'app/users/userForm.html'
      bindToController:
        user: '='
      controllerAs: 'ctrl'
      controller: ( $scope, $state, User, Flash, pundit ) ->
        ctrl = this
        pundit { policy: 'user' }, ( permissions ) ->
          $scope.may = permissions
        $scope.user = ctrl.user
        $scope.errors = { }
        $scope.adminOptions = [
          [ true, 'Is Administrator' ]
          [ false, 'Not Administrator' ]
        ]
        $scope.staffOptions = [
          [ true, 'Is Staff' ]
          [ false, 'Not Staff' ]
        ]
        $scope.setMemberships = (memberships) ->
          $scope.user.jurisdictionMemberships = memberships
        setJurisdictionMembershipsAttributes = () ->
          $scope.user.jurisdictionMembershipsAttributes = []
          for membership in $scope.user.jurisdictionMemberships
            attributes =  {
              propose: membership.propose
              adopt: membership.adopt
            }
            attributes.jurisdictionId = membership.jurisdiction.id if membership.jurisdiction
            attributes.id = membership.id if membership.id
            attributes._destroy = true if membership.destroy
            $scope.user.jurisdictionMembershipsAttributes.push attributes
        $scope.save = ( user ) ->
          if $scope.user.jurisdictionMemberships && $scope.user.jurisdictionMemberships.length > 0
            setJurisdictionMembershipsAttributes()
          onCreate = ( user ) ->
            Flash.create 'success', 'User created'
            $state.go 'users'
          onUpdate = ( user ) ->
            Flash.create 'success', 'User updated'
            $state.go 'users'
          failure = ( response ) ->
            Flash.create 'danger', 'Save failed'
            $scope.errors = response.data.errors
          if user.id
            user.$save { }, onUpdate, failure
          else
            User.create user, onCreate, failure
        $scope.cancel = () ->
          $state.go 'users'
    }
