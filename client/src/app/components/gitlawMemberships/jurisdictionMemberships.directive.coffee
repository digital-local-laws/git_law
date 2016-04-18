angular.module 'gitlawMemberships'
  .directive 'jurisdictionMemberships', () -> {
    scope: {}
    templateUrl: 'app/components/gitlawMemberships/jurisdictionMemberships.html'
    controllerAs: 'ctrl'
    bindToController:
      memberships: '='
      onChange: '&'
    controller: ( $scope ) ->
      ctrl = this
      $scope.memberships = angular.copy ctrl.memberships
      $scope.set = (i,key,value) ->
        $scope.memberships[i][key] = value
        updateMemberships()
      $scope.toggle = (i,key) ->
        $scope.set i, key, !$scope.memberships[i][key]
      $scope.remove = (i) ->
        if $scope.memberships[i].id
          $scope.memberships[i].destroy = true
        else
          $scope.memberships.splice i, 1
        updateMemberships()
      updateMemberships = () ->
        ctrl.onChange { memberships: $scope.memberships }
      $scope.add = () ->
        $scope.memberships.push {
          adopt: false
          propose: false
        }
        updateMemberships()
  }
