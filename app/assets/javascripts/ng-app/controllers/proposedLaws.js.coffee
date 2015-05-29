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
      $scope.list.proposedLaws = ProposedLaw.jurisdictionQuery(
        { jurisdictionId: $stateParams.jurisdictionId, page: $scope.list.page },
        ( (proposedLaws, response) ->
            r = response()
            $scope.list.totalPages = r['x-total']
            $scope.list.perPage = r['x-per-page'] ) )
    $scope.setPage = ( page ) ->
      $state.go('.paginated', { page: page })
    $scope.closeAlert = (index) ->
      $scope.alerts.splice index, 1
    $scope.proposeLaw = (jurisdiction) ->
      modalInstance = $modal.open( {
        templateUrl: 'proposedLawSettings/new.html',
        controller: 'ProposedLawSettingsCtrl',
        resolve: {
          jurisdiction: ( -> $scope.jurisdiction )
          proposedLaw: ( -> new ProposedLaw({jurisdictionId: $stateParams.jurisdictionId}) ) } } )
      modalInstance.result.then(
        ( (proposedLaw) ->
          $state.go('proposedLaw.initialize',{proposedLawId:proposedLaw.id}) ),
        ( () -> false ) )
  ] )
