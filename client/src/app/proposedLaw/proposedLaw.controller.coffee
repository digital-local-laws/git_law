angular.module 'client'
  .controller 'ProposedLawCtrl', ( $scope, proposedLaw, Jurisdiction,
    pundit ) ->
      $scope.onProposedLawLoad = ( proposedLaw ) ->
        pundit(
          {
            policy: 'proposedLaw'
            proposedLaw: proposedLaw
            jurisdictionId: proposedLaw.jurisdictionId
          }
          ( permissions ) ->
            $scope.may = permissions
        )
        $scope.proposedLaw = proposedLaw
        Jurisdiction.get(
          { jurisdictionId: proposedLaw.jurisdictionId }
          ( jurisdiction ) ->
            $scope.jurisdiction = jurisdiction
        )
      $scope.onProposedLawLoad proposedLaw
