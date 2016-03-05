angular.module 'client'
  .directive 'proposedLawList', () ->
    {
      scope: {}
      templateUrl: 'app/proposedLaws/proposedLawList.html'
      controllerAs: 'ctrl'
      bindToController:
        page: '='
        jurisdiction: '='
        onSetPage: '&'
      controller: ( $scope, pundit, $uibModal, $state, ProposedLaw, Flash ) ->
        ctrl = this
        ProposedLaw.jurisdictionQuery(
          { jurisdictionId: ctrl.jurisdiction.id, page: ctrl.page },
          (proposedLaws, response) ->
            r = response()
            $scope.totalPages = r['x-total']
            $scope.perPage = r['x-per-page']
            $scope.proposedLaws = proposedLaws
            for law, i in proposedLaws
              pundit(
                {
                  policy: 'proposedLaw'
                  jurisdictionId: law.jurisdictionId
                  proposedLaw: law
                }
                ( permissions ) ->
                  law['may'] = permissions
              )
        )
        $scope.setPage = (page) ->
          ctrl.onSetPage({page: page})
        $scope.editProposedLawSettings = (proposedLaw) ->
          $state.go 'proposedLaw.edit', { proposedLawId: proposedLaw.id }
        $scope.destroyProposedLaw = (proposedLaw) ->
          proposedLaw.$delete(
            {}
            () ->
              Flash.create 'info', 'Proposed law was removed.'
              $state.go '.'
            () ->
              Flash.create 'danger', 'Proposed law could not be removed.'
          )
    }
