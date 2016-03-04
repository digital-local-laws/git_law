angular.module 'client'
  .controller 'ProposedLawSettingsCtrl', ( $scope, proposedLaw ) ->
    $scope.proposedLaw = proposedLaw
