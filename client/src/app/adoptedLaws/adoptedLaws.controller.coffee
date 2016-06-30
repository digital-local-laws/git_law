angular.module 'client'
  .controller 'AdoptedLawsCtrl', ( $scope, $stateParams, $state,
    AdoptedLaw, pundit, $log ) ->
      ctrl = this
      $scope.may = {}
      $scope.page = $stateParams.page || 1
      ctrl.setPage = ( page ) ->
        $state.go('.', { page: page })
