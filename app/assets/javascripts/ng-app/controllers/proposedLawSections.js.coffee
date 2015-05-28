angular
  .module 'gitLaw'
  .controller( 'ProposedLawSectionsCtrl', ['$scope', '$stateParams',
  ( $scope, $stateParams ) ->
    $scope.views = [ [ "show", "Show" ] ]
  ] )

