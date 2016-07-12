angular.module 'client'
  .directive 'gitlabClientIdentities', () ->
    {
      scope: {}
      templateUrl: 'app/gitlabClientIdentities/gitlabClientIdentities.html'
      controllerAs: 'ctrl'
      bindToController:
        user: '='
      controller:  ( $scope, $state, pundit, $log ) ->
        ctrl = this
        $scope.user = angular.copy ctrl.user
        $scope.may = {}
        pundit(
          {
            policy: 'gitlabClientIdentity'
            action: 'create'
            userId: $scope.user.id
          }
          ( permission ) ->
            $scope.may.create = permission
        )
        $scope.page = 1
        ctrl.setPage = ( page ) ->
          $scope.page = page
        $scope.newGitlabClientIdentity = (user) ->
          $state.go(
            'user.newGitlabClientIdentity', { userId: user.id }
          )
        }
