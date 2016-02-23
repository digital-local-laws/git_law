angular.module 'client'
  .controller 'JurisdictionSettingsCtrl', ( $scope, $uibModalInstance,
    jurisdiction, Jurisdiction, Flash ) ->
      $scope.alerts = [ ]
      $scope.errors = { }
      $scope.jurisdiction = jurisdiction
      $scope.save = (jurisdiction) ->
        success = ( jurisdiction ) ->
          $uibModalInstance.close jurisdiction
        failure = ( response ) ->
          Flash.create( 'danger', 'Save failed.' )
          $scope.errors = response.data.errors
        if jurisdiction.id
          jurisdiction.$save( success, failure )
        else
          Jurisdiction.create( jurisdiction, success, failure )
      $scope.cancel = ->
        $uibModalInstance.dismiss()
