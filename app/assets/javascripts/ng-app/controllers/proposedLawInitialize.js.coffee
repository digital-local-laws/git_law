angular
  .module 'gitLaw'
  .controller( 'ProposedLawInitializeCtrl', ['$scope', '$state', '$timeout',
  'ProposedLaw'
  ( $scope, $state, $timeout, ProposedLaw ) ->
    # $scope.$watch 'proposedLaw.workingRepoCreated', (newVal, oldVal) ->
    #   return goBrowse() if newVal
    reloadProposedLaw = ->
      ProposedLaw.get({proposedLawId:$scope.proposedLaw.id},$scope.onProposedLawLoad)
      return $state.go('^.browse') if $scope.proposedLaw.workingRepoCreated
      $timeout( reloadProposedLaw, 1000 ) unless $scope.proposedLaw.workingRepoCreated
    reloadProposedLaw()
  ] )
