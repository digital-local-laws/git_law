angular
  .module 'gitLaw'
  .controller( 'ProposedLawsCtrl', [ '$scope', '$modal', '$stateParams',
  '$state', 'ProposedLaw',
  ( $scope, $modal, $stateParams, $state, ProposedLaw ) ->
    $scope.alerts = [ ]
    $scope.list = {
      page: 1,
      proposedLaws: [] }
    $scope.reloadList = ->
      $scope.list.proposedLaws = ProposedLaw.codeQuery(
        { codeId: $stateParams.codeId, page: $scope.list.page },
        ( (proposedLaws, response) ->
            r = response()
            $scope.list.totalPages = r['x-total']
            $scope.list.perPage = r['x-per-page'] ) )
    $scope.setPage = ( page ) ->
      $state.go('.paginated', { page: page })
    $scope.closeAlert = (index) ->
      $scope.alerts.splice index, 1
    $scope.proposeLaw = (code) ->
      modalInstance = $modal.open( {
        templateUrl: 'proposedLawSettings/new.html',
        controller: 'ProposedLawSettingsCtrl',
        resolve: {
          code: ( -> $scope.code )
          proposedLaw: ( -> new ProposedLaw({codeId: $stateParams.codeId}) ) } } )
      modalInstance.result.then(
        ( (proposedLaw) ->
          $scope.alerts.push( {
            type: 'success',
            msg: "Proposed law was added." } )
          $scope.reloadList() ),
        ( () -> false ) )
  ] )
