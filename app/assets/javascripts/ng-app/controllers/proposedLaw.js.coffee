angular
  .module 'gitLaw'
  .controller( 'ProposedLawCtrl', ['$scope', '$stateParams',
  '$timeout', 'proposedLaw',
  ( $scope, $stateParams, $timeout, proposedLaw ) ->
    $scope.onProposedLawLoad = (proposedLaw) ->
      $scope.proposedLaw = proposedLaw
      $scope.jurisdiction = proposedLaw.jurisdiction
    $scope.onProposedLawLoad proposedLaw
  ] )
