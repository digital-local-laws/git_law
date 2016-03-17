angular.module 'client'
  .directive 'userForm', () ->
    {
      scope: {}
      templateUrl: 'app/users/userForm.html'
      bindToController:
        user: '='
      controllerAs: 'ctrl'
      controller: ( $scope, $state, User, Flash ) ->
        ctrl = this
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
        $scope.save = ( user ) ->
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
