angular.module 'client'
  .controller 'JurisdictionsCtrl', ( $scope, $uibModal, $stateParams, $state,
    Jurisdiction, Flash, pundit ) ->
      pundit { policy: 'jurisdiction' }, ( permissions ) ->
        $scope.may = permissions
      $scope.alerts = [ ]
      $scope.list = {
        page: 1,
        jurisdictions: [] }
      $scope.reloadList = ->
        $scope.list.jurisdictions = Jurisdiction.query(
          { page: $scope.list.page }
          (jurisdictions, response) ->
            r = response()
            $scope.list.totalPages = r['x-total']
            $scope.list.perPage = r['x-per-page']
        )
      $scope.setPage = ( page ) ->
        $state.go('jurisdictions.paginated', { page: page })
      $scope.closeAlert = (index) ->
        $scope.alerts.splice index, 1
      $scope.newJurisdiction = ->
        modalInstance = $uibModal.open( {
          templateUrl: 'app/jurisdictionSettings/new.html',
          controller: 'JurisdictionSettingsCtrl',
          resolve: {
            jurisdiction: ( -> new Jurisdiction ) } } )
        modalInstance.result.then(
          (jurisdiction) ->
            Flash.create 'success', 'Jurisdiction was added.'
            $scope.reloadList()
          () -> false
        )
