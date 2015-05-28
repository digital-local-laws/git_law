angular
  .module 'gitLaw'
  .controller( 'ProposedLawCtrl', ['$scope', '$stateParams', '$modal',
  'ProposedLaw', 'proposedLaw'
  ( $scope, $stateParams, $modal, ProposedLaw, proposedLaw ) ->
    $scope.proposedLaw = proposedLaw
    $scope.jurisdiction = proposedLaw.jurisdiction
  ] )

