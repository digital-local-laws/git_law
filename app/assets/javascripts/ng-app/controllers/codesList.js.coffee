angular
  .module 'gitLaw'
  .controller( 'CodesListCtrl', [ '$scope', '$modal', '$stateParams', 'Code',
    ( $scope, $modal, $stateParams, Code ) ->
      $scope.reloadList = ->
        $scope.list.codes = Code.query(
          { page: $scope.list.page },
          ( (codes, response) ->
              r = response()
              $scope.list.totalPages = r['x-total']
              $scope.list.perPage = r['x-per-page'] ) )
      $scope.editCode = (code) ->
        modalInstance = $modal.open( {
          templateUrl: 'code/edit.html',
          controller: 'CodeCtrl',
          resolve: {
            code: ( -> code ) } } )
        modalInstance.result.then(
          ( (code) ->
            $scope.alerts.push( {
              type: 'success',
              msg: "Code was updated." } )
            $scope.reloadList() ),
          ( () -> false ) )
      $scope.destroyCode = (code) ->
        code.$delete(
          {},
          ( () -> 
              $scope.alerts.push( { 
                type: 'info'
                msg: 'Code was removed.'
              } )
              $scope.reloadList() ),
          ( () -> $scope.alerts.push( {
            type: 'danger'
            msg: 'Code could not be removed.'
          } ) )
        )
      $stateParams.page = 1 unless $stateParams.page
      $scope.list.page = $stateParams.page
      $scope.reloadList()
  ] )
