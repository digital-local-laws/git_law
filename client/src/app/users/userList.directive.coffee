angular.module 'client'
  .directive 'userList', () ->
    {
      scope: {}
      templateUrl: 'app/users/userList.html'
      controllerAs: 'ctrl'
      bindToController:
        may: '='
        onSetPage: '&'
        onSetSearch: '&'
      controller: ( $scope, $state, User, Flash ) ->
        ctrl = this
        $scope.may = ctrl.may
        loadUsers = ( search, page ) -> User.query(
          { q: search, page: page }
          ( users, response ) ->
            r = response()
            $scope.totalPages = r['x-total']
            $scope.perPage = r['x-per-page']
            $scope.users = users
        )
        $scope.$watchCollection '[search,page]', ( nVal, oVal ) ->
          loadUsers( nVal[0], nVal[1] )
        loadUsers()
        $scope.setPage = ( page ) ->
          loadUsers( $scope.search, $scope.page )
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
