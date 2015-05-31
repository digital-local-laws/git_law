angular
  .module 'gitLaw'
  .controller( 'ProposedLawInitializeCtrl', ['$scope', '$state', '$timeout',
  'ProposedLaw'
  ( $scope, $state, $timeout, ProposedLaw ) ->
    timeout = null
    reloadProposedLaw = ->
      $timeout.cancel timeout
      ProposedLaw.get({proposedLawId:$scope.proposedLaw.id},$scope.onProposedLawLoad)
      if $scope.proposedLaw.workingRepoCreated
        $state.go('proposedLaw.browse',{proposedLawId:$scope.proposedLaw.id})
      else
        timeout = $timeout( reloadProposedLaw, 1000 )
    reloadProposedLaw()
    # timeout = null
    # debounceReloadProposedLaw = (newVal, oldVal)->
    #   unless newVal
    #     $timeout.cancel timeout
    #
    #   $timeout.cancel( timeout ) if timeout
    #   if newVal
    #     $state.go('proposedLaw.browse',{proposedLawId:$scope.proposedLaw.id})
    #   else
    #     timeout = $timeout( reloadProposedLaw, 1000 )
    # $scope.$watch('proposedLaw.workingRepoCreated', debounceReloadProposedLaw)
    # debounceReloadProposedLaw()
  ] )
