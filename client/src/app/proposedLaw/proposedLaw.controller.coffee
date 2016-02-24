angular.module 'client'
  .controller 'ProposedLawCtrl', ( $scope, proposedLaw, Jurisdiction, $log ) ->
    $scope.onProposedLawLoad = ( proposedLaw ) ->
      $scope.proposedLaw = proposedLaw
      Jurisdiction.get(
        { jurisdictionId: proposedLaw.jurisdictionId }
        ( jurisdiction ) ->
          $scope.jurisdiction = jurisdiction
      )
    $scope.onProposedLawLoad proposedLaw
