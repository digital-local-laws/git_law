angular.module 'client'
  .directive 'gitlawNavbar', ->
    NavbarController = ($auth, $log, $scope) ->
      'ngInject'
      vm = this
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
