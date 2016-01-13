angular
  .module 'gitLaw'
  .controller( 'JurisdictionSettingsCtrl', ['$scope', '$uibModalInstance',
  '$upload', 'jurisdiction', 'Jurisdiction',
  ( $scope, $uibModalInstance, $upload, jurisdiction, Jurisdiction ) ->
    $scope.alerts = [ ]
    $scope.errors = { }
    $scope.jurisdiction = jurisdiction
    $scope.save = (jurisdiction) ->
      success = ( jurisdiction ) ->
        $uibModalInstance.close jurisdiction
      failure = ( response ) ->
        $scope.alerts.push( { type: 'danger', msg: "Save failed." } )
        $scope.errors = response.data.errors
      if jurisdiction.id
        jurisdiction.$save( success, failure )
      else
        Jurisdiction.create( jurisdiction, success, failure )
    $scope.cancel = ->
      $uibModalInstance.dismiss()
  ])
