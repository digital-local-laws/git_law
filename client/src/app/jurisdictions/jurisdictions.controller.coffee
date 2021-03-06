angular.module 'client'
  .controller 'JurisdictionsCtrl', ( $scope, $stateParams, $state,
    Flash, pundit ) ->
      pundit { policy: 'jurisdiction' }, ( permissions ) ->
        $scope.may = permissions
      $scope.setPage = ( page ) ->
        $state.go '.', { page: page }
      $scope.newJurisdiction = ->
        $state.go 'newJurisdiction'
