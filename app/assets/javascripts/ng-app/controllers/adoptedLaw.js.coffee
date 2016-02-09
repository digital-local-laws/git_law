angular
  .module 'gitLaw'
  .controller( 'AdoptedLawCtrl', ['$scope', '$stateParams','AdoptedLaw',
  ( $scope, $stateParams, AdoptedLaw ) ->
    AdoptedLaw.get( {adoptedLawId: $stateParams.adoptedLawId}, ( adoptedLaw ) ->
      $scope.adoptedLaw = adoptedLaw
      $scope.jurisdiction = adoptedLaw.jurisdiction
    )
  ] )
