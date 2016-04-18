angular.module 'gitlawJurisdictionPicker'
  .directive 'jurisdictionPicker', () -> {
    scope: {}
    templateUrl: 'app/components/gitlawJurisdictionPicker/gitlawJurisdictionPicker.html'
    controllerAs: 'ctrl'
    bindToController:
      jurisdiction: '='
      onChange: '&'
    controller: ( Jurisdiction, $scope ) ->
      ctrl = this
      if ctrl.jurisdiction
        $scope.selected = angular.copy ctrl.jurisdiction
      else
        $scope.selected = {}
      $scope.onSelect = ( item ) ->
        ctrl.onChange { jurisdiction: item }
      $scope.searchJurisdictions = (search) ->
        unless search
          return $scope.jurisdictions = []
        Jurisdiction.query(
          { q: search }
          ( jurisdictions ) ->
            $scope.jurisdictions = jurisdictions
          () ->
            $scope.jurisdictions = []
        )
  }
