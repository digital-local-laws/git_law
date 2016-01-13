angular
  .module 'gitLaw'
  .controller( 'JurisdictionsListCtrl', [ '$scope', '$uibModal', '$stateParams', 'Jurisdiction',
    ( $scope, $uibModal, $stateParams, Jurisdiction ) ->
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
            $scope.alerts.push( {
              type: 'success',
              msg: "Jurisdiction settings were updated." } )
            $scope.reloadList() ),
          ( () -> false ) )
      $scope.destroyJurisdiction = (jurisdiction) ->
        jurisdiction.$delete(
          {},
          ( () -> 
              $scope.alerts.push( { 
                type: 'info'
                msg: 'Jurisdiction was removed.'
              } )
              $scope.reloadList() ),
          ( () -> $scope.alerts.push( {
            type: 'danger'
            msg: 'Jurisdiction could not be removed.'
          } ) )
        )
      $stateParams.page = 1 unless $stateParams.page
      $scope.list.page = $stateParams.page
      $scope.reloadList()
  ] )
