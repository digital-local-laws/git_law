angular
  .module 'gitLaw'
  .controller( 'UserSessionCtrl', ['$scope', '$state', '$window',
  ( $scope, $state, $window ) ->
    $scope.signIn = (provider) ->
      $window.location.href = "/auth/" + provider
    $scope.cancel = ->
      $state.go( 'home' )
  ])
