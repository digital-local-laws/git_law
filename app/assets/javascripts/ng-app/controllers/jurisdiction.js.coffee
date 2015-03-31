angular
  .module 'gitLaw'
  .controller( 'JurisdictionCtrl', ['$scope', '$stateParams', 'Jurisdiction',
  ( $scope, $stateParams, Jurisdiction ) ->
    $scope.jurisdiction = Jurisdiction.get({jurisdictionId: $stateParams.jurisdictionId})
    $scope.tabs = [
      [ 'proposed', 'Proposed Laws' ]
      [ 'adopted', 'Adopted Laws' ]
    ]
  ] )

