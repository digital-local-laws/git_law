angular.module 'client'
  .directive 'adoptedLawList', () ->
    {
      scope: {}
      templateUrl: 'app/adoptedLaws/adoptedLawList.html'
      controllerAs: 'ctrl'
      bindToController:
        page: '='
        jurisdiction: '='
        onSetPage: '&'
      controller: ( $scope, pundit, $state, AdoptedLaw, Flash ) ->
        ctrl = this
        parameters = { page: ctrl.page }
        parameters.jurisdictionId = ctrl.jurisdiction.id if ctrl.jurisdiction
        AdoptedLaw.query(
          parameters,
          (adoptedLaws, response) ->
            r = response()
            $scope.totalPages = r['x-total']
            $scope.perPage = r['x-per-page']
            $scope.adoptedLaws = adoptedLaws
            for law, i in adoptedLaws
              pundit(
                {
                  policy: 'adoptedLaw'
                  jurisdictionId: law.jurisdictionId
                  adoptedLaw: law
                }
                ( permissions ) ->
                  law['may'] = permissions
              )
        )
        $scope.setPage = (page) ->
          ctrl.onSetPage({page: page})
    }
