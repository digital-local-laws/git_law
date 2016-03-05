angular.module 'client'
  .directive 'jurisdictionList', () ->
    {
      scope: {}
      templateUrl: 'app/jurisdictions/jurisdictionList.html'
      controllerAs: 'ctrl'
      bindToController:
        may: '='
        page: '='
        onSetPage: '&'
      controller: ( $scope, $state, Jurisdiction, Flash ) ->
        ctrl = this
        $scope.may = ctrl.may
        $scope.page = ctrl.page
        Jurisdiction.query(
          { page: ctrl.page }
          ( jurisdictions, response ) ->
            r = response()
            $scope.totalPages = r['x-total']
            $scope.perPage = r['x-per-page']
            $scope.jurisdictions = jurisdictions
        )
        $scope.editJurisdiction = ( jurisdiction ) ->
          $state.go 'jurisdiction.edit', { jurisdictionId: jurisdiction.id }
        $scope.destroyJurisdiction = (jurisdiction) ->
          jurisdiction.$delete(
            {}
            () ->
              Flash.create 'info', 'Jurisdiction was removed.'
              $state.go '.'
            () ->
              Flash.create 'danger', 'Jurisdiction could not be removed.'
          )
    }
