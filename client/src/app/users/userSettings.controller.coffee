angular.module 'client'
  .controller 'UserSettingsCtrl', ( $scope, user ) ->
    $scope.user = user
