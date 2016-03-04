angular.module 'client'
  .controller 'ProposedLawsCtrl', ( $scope, $uibModal, $stateParams, $state,
    ProposedLaw, pundit, $log ) ->
      ctrl = this
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
      $scope.page = $stateParams.page || 1
      ctrl.setPage = ( page ) ->
        $state.go('.', { page: page })
      $scope.proposeLaw = (jurisdiction) ->
        modalInstance = $uibModal.open( {
          templateUrl: 'app/proposedLawSettings/new.html',
          controller: 'ProposedLawSettingsCtrl',
          resolve: {
            jurisdiction: ( -> $scope.jurisdiction )
            proposedLaw: ( -> new ProposedLaw({
              jurisdictionId: $stateParams.jurisdictionId
            }) ) } } )
        modalInstance.result.then(
          ( (proposedLaw) ->
            $state.go('proposedLaw.initialize',{proposedLawId:proposedLaw.id}) ),
          ( () -> false ) )
