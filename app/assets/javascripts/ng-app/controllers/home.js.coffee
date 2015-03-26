angular
  .module 'gitLaw'
  .controller 'HomeCtrl', [ '$scope', '$controller', ($scope, $controller) ->
    $scope.things = ['Angular', 'Rails 4.1', 'UI Router', 'Together!']
  ]
