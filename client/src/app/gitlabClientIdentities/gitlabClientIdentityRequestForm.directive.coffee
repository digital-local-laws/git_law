angular.module 'client'
  .directive 'gitlabClientIdentityRequestForm', () ->
    {
      scope: {}
      templateUrl: 'app/gitlabClientIdentities/gitlabClientIdentityRequestForm.html'
      controllerAs: 'ctrl'
      bindToController:
        user: '='
      controller: ( $scope, $state, $window, Flash, GitlabClientIdentityRequest ) ->
        ctrl = this
        $scope.errors = { }
        $scope.gitlabClientIdentityRequest = {
          userId: ctrl.user.id
        }
        $scope.save = ( gitlabClientIdentityRequest ) ->
          onCreate = ( gitlabClientIdentityRequest ) ->
            $window.location.href = gitlabClientIdentityRequest.authorizationUri
          failure = ( response ) ->
            Flash.create( 'danger', 'Save failed.' )
            $scope.errors = response.data.errors
          GitlabClientIdentityRequest.create( gitlabClientIdentityRequest, onCreate, failure )
        $scope.cancel = ->
          $state.go 'user.clientIdentities',
            { userId: $scope.gitlabClientIdentity.userId }
    }
