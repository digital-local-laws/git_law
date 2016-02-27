angular.module 'client'
  .controller 'ProposedLawsCtrl', ( $scope, $uibModal, $stateParams, $state,
    ProposedLaw, pundit, $log ) ->
      $scope.may = {}
      pundit(
        {
          policy: 'proposedLaw'
          action: 'create'
          jurisdictionId: $scope.jurisdiction.id
        }
        ( permission ) ->
          $scope.may.create = permission
      )
      $scope.alerts = [ ]
      $scope.list = {
        page: 1,
        proposedLaws: [] }
      $scope.reloadList = ->
        ProposedLaw.jurisdictionQuery(
          { jurisdictionId: $stateParams.jurisdictionId, page: $scope.list.page },
          (proposedLaws, response) ->
            r = response()
            $scope.list.totalPages = r['x-total']
            $scope.list.perPage = r['x-per-page']
            $scope.list.proposedLaws = proposedLaws
            for law, i in proposedLaws
              pundit(
                {
                  policy: 'proposedLaw'
                  jurisdictionId: $stateParams.jurisdictionId
                  proposedLaw: law
                }
                ( permissions ) ->
                  law['may'] = permissions
              )
        )
      $scope.setPage = ( page ) ->
        $state.go('.paginated', { page: page })
      $scope.closeAlert = (index) ->
        $scope.alerts.splice index, 1
      $scope.proposeLaw = (jurisdiction) ->
        modalInstance = $uibModal.open( {
          templateUrl: 'app/proposedLawSettings/new.html',
          controller: 'ProposedLawSettingsCtrl',
          resolve: {
            jurisdiction: ( -> $scope.jurisdiction )
            proposedLaw: ( -> new ProposedLaw({jurisdictionId: $stateParams.jurisdictionId}) ) } } )
        modalInstance.result.then(
          ( (proposedLaw) ->
            $state.go('proposedLaw.initialize',{proposedLawId:proposedLaw.id}) ),
          ( () -> false ) )
