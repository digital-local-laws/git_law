angular.module 'client'
  .controller 'JurisdictionSettingsCtrl', ( $scope, $state, jurisdiction,
    Jurisdiction, Flash ) ->
      $scope.errors = { }
      $scope.jurisdiction = jurisdiction
      $scope.save = ( jurisdiction ) ->
        onCreate = ( jurisdiction ) ->
          Flash.create 'success', 'Jurisdiction was added.'
          $state.go 'jurisdiction.proposedLaws', { jurisdictionId: jurisdiction.id, page: 1 }
        onUpdate = ( jurisdiction ) ->
          Flash.create 'success', 'Jurisdiction settings were updated.'
          $state.go 'jurisdictions', { page: 1 }
        failure = ( response ) ->
          Flash.create( 'danger', 'Save failed.' )
          $scope.errors = response.data.errors
        if jurisdiction.id
          jurisdiction.$save onUpdate, failure
        else
          Jurisdiction.create jurisdiction, onCreate, failure
      $scope.cancel = ->
        $state.go 'jurisdictions', { page: 1 }
