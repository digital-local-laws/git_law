angular.module 'gitlawModels'
  # Factory produces a promise that resolves either to an existing
  # proposedLawNode resource or attributes of a new proposedLawNode resource
  # populated from current state.
  .factory 'proposedLawNodeState', ( ProposedLawNode, $q ) ->
    return (params) ->
      ProposedLawNode.get( {
        proposedLawId: params.proposedLawId
        treeBase: params.treeBase } ).$promise
