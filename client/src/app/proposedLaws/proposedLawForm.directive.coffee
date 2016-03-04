angular.module 'client'
  .directive 'proposedLawForm', () ->
    {
      scope: {}
      templateUrl: 'app/proposedLaws/proposedLawForm.html'
      controller: ( $scope, $state, Flash, ProposedLaw ) ->
        ctrl = this
        $scope.errors = { }
        $scope.proposedLaw = angular.copy ctrl.proposedLaw
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
      controllerAs: 'ctrl'
      bindToController:
        proposedLaw: '='
    }
