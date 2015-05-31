angular
  .module 'gitLaw'
  .controller( 'ProposedLawInitializeCtrl', ['$scope', '$state', '$timeout',
  'ProposedLaw'
  ( $scope, $state, $timeout, ProposedLaw ) ->
    timeout = null
    reloadProposedLaw = ->
      ProposedLaw.get({proposedLawId:$scope.proposedLaw.id},$scope.onProposedLawLoad)
    debounceReloadProposedLaw = (newVal, oldVal)->
      $timeout.cancel( timeout ) if timeout
      if newVal
        $state.go('proposedLaw.browse',{proposedLawId:$scope.proposedLaw.id})
      else
        timeout = $timeout( reloadProposedLaw, 1000 )
    $scope.$watch('proposedLaw.workingRepoCreated', debounceReloadProposedLaw)
  ] )
