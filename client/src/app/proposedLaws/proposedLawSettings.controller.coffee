angular.module 'client'
  .controller 'ProposedLawSettingsCtrl', ( $scope, ProposedLaw, Jurisdiction,
    Flash, proposedLaw, $state, $stateParams ) ->
      $scope.errors = { }
      Jurisdiction
        .get({ jurisdictionId: proposedLaw.jurisdictionId }).$promise
        .then ( jurisdiction ) ->
          $scope.jurisdiction = jurisdiction
      $scope.proposedLaw = proposedLaw
      $scope.save = ( proposedLaw ) ->
        onCreate = ( proposedLaw ) ->
          Flash.create 'success', 'Proposed law created.'
          $state.go(
            'proposedLaw.initialize'
            { proposedLawId: proposedLaw.id }
          )
        onUpdate = ( proposedLaw ) ->
          Flash.create 'success', 'Proposed law settings were updated.'
          $state.go(
            'jurisdiction.proposedLaws'
            { jurisdictionId: proposedLaw.jurisdictionId, page: 1 }
          )
        failure = ( response ) ->
          Flash.create( 'danger', 'Save failed.' )
          $scope.errors = response.data.errors
        if proposedLaw.id
          proposedLaw.$save( onUpdate, failure )
        else
          ProposedLaw.create( proposedLaw, onCreate, failure )
      $scope.cancel = ->
        $state.go 'jurisdiction.proposedLaws',
          { jurisdictionId: $scope.proposedLaw.jurisdictionId }
