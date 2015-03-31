angular
  .module 'gitLaw'
  .controller( 'JurisdictionsCtrl', [ '$scope', '$modal', '$stateParams', '$state', 'Jurisdiction',
    ( $scope, $modal, $stateParams, $state, Jurisdiction ) ->
      $scope.alerts = [ ]
      $scope.list = {
        page: 1,
        jurisdictions: [] }
      $scope.reloadList = ->
        $scope.list.jurisdictions = Jurisdiction.query(
          { page: $scope.list.page },
          ( (jurisdictions, response) ->
              r = response()
              $scope.list.totalPages = r['x-total']
              $scope.list.perPage = r['x-per-page'] ) )
      $scope.setPage = ( page ) ->
        $state.go('jurisdictions.paginated', { page: page })
      $scope.closeAlert = (index) ->
        $scope.alerts.splice index, 1
      $scope.newJurisdiction = ->
        modalInstance = $modal.open( {
          templateUrl: 'jurisdictionSettings/new.html',
          controller: 'JurisdictionSettingsCtrl',
          resolve: {
            jurisdiction: ( -> new Jurisdiction ) } } )
        modalInstance.result.then(
          ( (jurisdiction) ->
            $scope.alerts.push( {
              type: 'success',
              msg: "Jurisdiction was added." } )
            $scope.reloadList() ),
          ( () -> false ) )
  ] )
