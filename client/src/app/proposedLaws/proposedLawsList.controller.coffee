angular.module 'client'
  .controller 'ProposedLawsListCtrl', ( $scope, $uibModal, $stateParams,
    $state, ProposedLaw, Flash ) ->
      $scope.editProposedLaw = (proposedLaw) ->
        $state.go( 'proposedLaw.sections.show',
        { proposedLawId: proposedLaw.id } )
      $scope.editProposedLawSettings = (proposedLaw) ->
        modalInstance = $uibModal.open( {
          templateUrl: 'app/proposedLawSettings/edit.html',
          controller: 'ProposedLawSettingsCtrl',
          resolve: {
            jurisdiction: ( -> $scope.jurisdiction )
            proposedLaw: ( -> proposedLaw ) } } )
        modalInstance.result.then(
          (proposedLaw) ->
            Flash.create( 'success', 'Proposed law settings were updated.' )
            $scope.reloadList()
          () -> false
        )
      $scope.destroyProposedLaw = (proposedLaw) ->
        proposedLaw.$delete(
          {}
          () ->
            Flash.create( 'info', 'Proposed law was removed.' )
            $scope.reloadList()
          () ->
            Flash.create('danger', 'Proposed law could not be removed.' )
        )
      $stateParams.page = 1 unless $stateParams.page
      $scope.list.page = $stateParams.page
      $scope.reloadList()
