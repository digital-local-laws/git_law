angular.module 'client'
  .directive 'userList', () ->
    {
      scope: {}
      templateUrl: 'app/users/userList.html'
      controllerAs: 'ctrl'
      bindToController:
        may: '='
        page: '='
        onSetPage: '&'
        onSetSearch: '&'
      controller: ( $scope, $state, User, Flash ) ->
        ctrl = this
        $scope.may = ctrl.may
        $scope.search = ctrl.search
        $scope.page = ctrl.page
        User.query(
          { q: $scope.search, page: ctrl.page }
          ( users, response ) ->
            r = response()
            $scope.totalPages = r['x-total']
            $scope.perPage = r['x-per-page']
            $scope.users = users
        )
        $scope.editUser = ( user ) ->
          $state.go 'user.edit', { userId: user.id }
        $scope.destroyUser = ( user ) ->
          user.$delete(
            {}
            () ->
              Flash.create 'info', 'User was removed.'
              $state.reload()
            () ->
              Flash.create 'danger', 'User could not be removed.'
          )
    }
