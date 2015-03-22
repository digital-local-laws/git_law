angular
  .module 'gitLaw'
  .controller( 'DashboardCtrl', [ '$state', '$scope', '$resource', '$http',
    '$sanitize', '$templateCache', '$stateParams',
    ( $state, $scope, $resource, $http, $sanitize, $templateCache,
      $stateParams ) ->
  ] )
