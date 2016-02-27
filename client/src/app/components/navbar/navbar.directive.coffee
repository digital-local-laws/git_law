angular.module 'client'
  .directive 'gitlawNavbar', ->
    NavbarController = (moment, $auth, $log, $scope) ->
      'ngInject'
      vm = this
      # "vm.creation" is avaible by directive option "bindToController: true"
      vm.relativeDate = moment(vm.creationDate).fromNow()
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
