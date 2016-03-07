angular.module 'client'
  .directive 'jurisdictionForm', () ->
    {
      scope: {}
      templateUrl: 'app/jurisdiction/jurisdictionForm.html'
      bindToController:
        jurisdiction: '='
      controllerAs: 'ctrl'
      controller: ( $scope, $state, Jurisdiction, Flash ) ->
        ctrl = this
        $scope.jurisdiction = angular.copy ctrl.jurisdiction
        $scope.errors = { }
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
          if $scope.jurisdiction.id
            $scope.jurisdiction.$save onUpdate, failure
          else
            Jurisdiction.create $scope.jurisdiction, onCreate, failure
        $scope.cancel = ->
          $state.go 'jurisdictions', { page: 1 }
    }
