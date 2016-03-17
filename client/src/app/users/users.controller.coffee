angular.module 'client'
  .controller 'UsersCtrl', ( $scope, $state, pundit ) ->
    pundit { policy: 'user' }, ( permissions ) ->
      $scope.may = permissions
    $scope.page = 1
    $scope.search = ''
    $scope.setPage = ( page ) ->
      $scope.page = page
    $scope.setSearch = ( search ) ->
      $scope.search = search
    $scope.newUser = () ->
      $state.go 'newUser'
