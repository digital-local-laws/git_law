angular
  .module 'gitLaw'
  .controller( 'CodeCtrl', ['$scope', '$modalInstance',
  '$upload', 'code', 'Code',
  ( $scope, $modalInstance, $upload, code, Code ) ->
    $scope.alerts = [ ]
    $scope.errors = { }
    $scope.code = code
    $scope.save = (code) ->
      success = ( code ) ->
        $modalInstance.close code
      failure = ( response ) ->
        $scope.alerts.push( { type: 'danger', msg: "Save failed." } )
        $scope.errors = response.data.errors
      if code.id
        code.$save( success, failure )
      else
        Code.create( code, success, failure )
    $scope.cancel = ->
      $modalInstance.dismiss()
  ])
