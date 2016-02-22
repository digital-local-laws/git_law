angular.module 'client'
  .controller 'AdoptedLawCtrl', ( $scope, $stateParams, AdoptedLaw ) ->
    AdoptedLaw.get( {adoptedLawId: $stateParams.adoptedLawId}, ( adoptedLaw ) ->
      $scope.adoptedLaw = adoptedLaw
      $scope.jurisdiction = adoptedLaw.jurisdiction
    )
