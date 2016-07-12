angular.module 'client'
  .directive 'gitlabClientIdentityList', () ->
    {
      scope: {}
      templateUrl: 'app/gitlabClientIdentities/gitlabClientIdentityList.html'
      controllerAs: 'ctrl'
      bindToController:
        page: '='
        user: '='
        onSetPage: '&'
      controller: ( $scope, pundit, $state, GitlabClientIdentity, Flash ) ->
        ctrl = this
        GitlabClientIdentity.userQuery(
          { userId: ctrl.user.id, page: ctrl.page },
          (gitlabClientIdentities, response) ->
            r = response()
            $scope.totalPages = r['x-total']
            $scope.perPage = r['x-per-page']
            $scope.gitlabClientIdentities = gitlabClientIdentities
            for id, i in gitlabClientIdentities
              pundit(
                {
                  policy: 'gitlabClientIdentity'
                  userId: id.userId
                  gitlabClientIdentity: id
                }
                ( permissions ) ->
                  id['may'] = permissions
              )
        )
        $scope.setPage = (page) ->
          ctrl.onSetPage({page: page})
        $scope.editGitlabClientIdentitySettings = (gitlabClientIdentity) ->
          $state.go 'gitlabClientIdentity.edit', { gitlabClientIdentityId: gitlabClientIdentity.id }
        $scope.destroyGitlabClientIdentity = (gitlabClientIdentity) ->
          gitlabClientIdentity.$delete(
            {}
            () ->
              Flash.create 'info', 'Gitlab identity was removed.'
              $state.reload()
            () ->
              Flash.create 'danger', 'Gitlab identity could not be removed.'
          )
    }
