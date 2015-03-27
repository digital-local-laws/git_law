angular
  .module 'gitLaw'
  .controller( 'CodeCtrl', ['$scope', '$stateParams', 'Code',
  ( $scope, $stateParams, Code ) ->
    $scope.code = Code.get({codeId: $stateParams.codeId})
    $scope.tabs = [
      [ 'proposed', 'Proposed Laws' ]
      [ 'adopted', 'Adopted Laws' ]
    ]
  ] )

