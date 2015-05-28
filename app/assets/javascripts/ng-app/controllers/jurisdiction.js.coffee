angular
  .module 'gitLaw'
  .controller( 'JurisdictionCtrl', ['$scope', '$stateParams', 'Jurisdiction',
  ( $scope, $stateParams, Jurisdiction ) ->
    $scope.jurisdiction = Jurisdiction.get({jurisdictionId: $stateParams.jurisdictionId})
    $scope.tabs = [
      [ '.proposedLaws.paginated({page: 1})', 'Proposed Laws' ]
      [ 'adopted', 'Adopted Laws' ]
    ]
  ] )

