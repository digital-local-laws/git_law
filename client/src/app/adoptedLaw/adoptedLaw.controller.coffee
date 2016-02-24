angular.module 'client'
  .controller 'AdoptedLawCtrl', ( $scope, $stateParams, adoptedLaw,
  Jurisdiction, ProposedLaw ) ->
    onJurisdictionLoad = ( jurisdiction ) ->
      $scope.jurisdiction = jurisdiction
    onProposedLawLoad = ( proposedLaw ) ->
      $scope.proposedLaw = proposedLaw
      Jurisdiction.get { jurisdictionId: proposedLaw.jurisdictionId },
        onJurisdictionLoad
    onAdoptedLawLoad = ( adoptedLaw ) ->
      $scope.adoptedLaw = adoptedLaw
      ProposedLaw.get { proposedLawId: adoptedLaw.proposedLawId },
        onProposedLawLoad
    onAdoptedLawLoad adoptedLaw
