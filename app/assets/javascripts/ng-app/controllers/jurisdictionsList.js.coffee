angular
  .module 'gitLaw'
  .controller( 'JurisdictionsListCtrl', [ '$scope', '$uibModal', '$stateParams',
    'Jurisdiction', 'Flash',
    ( $scope, $uibModal, $stateParams, Jurisdiction, Flash ) ->
      $scope.reloadList = ->
        $scope.list.jurisdictions = Jurisdiction.query(
          { page: $scope.list.page },
          ( (jurisdictions, response) ->
              r = response()
              $scope.list.totalPages = r['x-total']
              $scope.list.perPage = r['x-per-page'] ) )
      $scope.editJurisdiction = (jurisdiction) ->
        modalInstance = $uibModal.open( {
          templateUrl: 'jurisdictionSettings/edit.html',
          controller: 'JurisdictionSettingsCtrl',
          resolve: {
            jurisdiction: ( -> jurisdiction ) } } )
        modalInstance.result.then(
          ( (jurisdiction) ->
            Flash.create( 'success', 'Jurisdiction settings were updated.' )
            $scope.reloadList() ),
          ( () -> false ) )
      $scope.destroyJurisdiction = (jurisdiction) ->
        jurisdiction.$delete(
          {},
          ( () ->
              Flash.create( 'info', 'Jurisdiction was removed.' )
              $scope.reloadList() ),
          ( () ->
              Flash.create( 'danger', 'Jurisdiction could not be removed.' ) )
        )
      $stateParams.page = 1 unless $stateParams.page
      $scope.list.page = $stateParams.page
      $scope.reloadList()
  ] )
