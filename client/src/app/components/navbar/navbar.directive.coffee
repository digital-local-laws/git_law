angular.module 'client'
  .directive 'gitlawNavbar', ->
    NavbarController = ($auth, $log, $scope, pundit) ->
      'ngInject'
      vm = this
      # Authorization control
      pundit { policy: 'global' }, ( permissions ) ->
        $scope.may = permissions
      # Sign out using NgTokenAuth service
      $scope.signOut = () ->
        $auth.signOut()
          .catch (resp) ->
            $log.error 'Signout failed'
      return
    directive =
      restrict: 'E'
      templateUrl: 'app/components/navbar/navbar.html'
      scope:
        creationDate: '='
      controller: NavbarController
      controllerAs: 'vm'
      bindToController: true
