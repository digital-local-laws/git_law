angular
  .module 'gitLaw'
  .controller( 'ProposedLawsListCtrl', [ '$scope', '$uibModal', '$stateParams',
    '$state', 'ProposedLaw',
    ( $scope, $uibModal, $stateParams, $state, ProposedLaw ) ->
      $scope.editProposedLaw = (proposedLaw) ->
        $state.go( 'proposedLaw.sections.show',
        { proposedLawId: proposedLaw.id } )
      $scope.editProposedLawSettings = (proposedLaw) ->
        modalInstance = $uibModal.open( {
          templateUrl: 'proposedLawSettings/edit.html',
          controller: 'ProposedLawSettingsCtrl',
          resolve: {
            jurisdiction: ( -> $scope.jurisdiction )
            proposedLaw: ( -> proposedLaw ) } } )
        modalInstance.result.then(
          ( (proposedLaw) ->
            $scope.alerts.push( {
              type: 'success',
              msg: "Proposed law settings were updated." } )
            $scope.reloadList() ),
          ( () -> false ) )
      $scope.destroyProposedLaw = (proposedLaw) ->
        proposedLaw.$delete(
          {},
          ( () -> 
              $scope.alerts.push( { 
                type: 'info'
                msg: 'Proposed law was removed.'
              } )
              $scope.reloadList() ),
          ( () -> $scope.alerts.push( {
            type: 'danger'
            msg: 'Proposed law could not be removed.'
          } ) )
        )
      $stateParams.page = 1 unless $stateParams.page
      $scope.list.page = $stateParams.page
      $scope.reloadList()
  ] )
