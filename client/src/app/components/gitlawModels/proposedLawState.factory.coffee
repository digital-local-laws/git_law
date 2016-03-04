angular.module 'gitlawModels'
  # Factory produces a promise that resolves either to an existing proposedLaw
  # resource or attributes of a new proposedLaw resource populated from current
  # state.
  .factory 'proposedLawState', ( ProposedLaw, $q ) ->
    return (params) ->
      if params.proposedLawId
        ProposedLaw.get({ proposedLawId: params.proposedLawId }).$promise
      else if params.jurisdictionId
        $q ( resolve ) ->
          resolve { jurisdictionId: params.jurisdictionId }
      else
        $q ( resolve, reject ) ->
          reject('Cannot populate from stateParams provided.')
