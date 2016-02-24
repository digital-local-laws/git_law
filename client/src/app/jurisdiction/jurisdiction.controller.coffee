angular.module 'client'
  .controller 'JurisdictionCtrl', ( $scope, $stateParams, jurisdiction ) ->
    $scope.jurisdiction = jurisdiction
    $scope.tabs = [
      [ '.proposedLaws.paginated({page: 1})', 'Proposed Laws' ]
      [ 'adopted', 'Adopted Laws' ]
    ]
