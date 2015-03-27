angular
  .module 'gitLaw'
  .controller( 'CodesCtrl', [ '$scope', '$modal', '$stateParams', '$state', 'Code',
    ( $scope, $modal, $stateParams, $state, Code ) ->
      $scope.alerts = [ ]
      $scope.list = {
        page: 1,
        codes: [] }
      $scope.reloadList = ->
        $scope.list.codes = Code.query(
          { page: $scope.list.page },
          ( (codes, response) ->
              r = response()
              $scope.list.totalPages = r['x-total']
              $scope.list.perPage = r['x-per-page'] ) )
      $scope.setPage = ( page ) ->
        $state.go('codes.paginated', { page: page })
      $scope.closeAlert = (index) ->
        $scope.alerts.splice index, 1
      $scope.newCode = ->
        modalInstance = $modal.open( {
          templateUrl: 'codeSettings/new.html',
          controller: 'CodeSettingsCtrl',
          resolve: {
            code: ( -> new Code ) } } )
        modalInstance.result.then(
          ( (code) ->
            $scope.alerts.push( {
              type: 'success',
              msg: "Code was added." } )
            $scope.reloadList() ),
          ( () -> false ) )
  ] )
