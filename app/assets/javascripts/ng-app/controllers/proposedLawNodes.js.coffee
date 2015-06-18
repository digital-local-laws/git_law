angular
  .module 'gitLaw'
  .controller( 'ProposedLawNodesCtrl', [ '$state', '$scope', '$stateParams',
  '$modal', '$timeout', 'ProposedLawNode', 'CodeLevel',
  ( $state, $scope, $stateParams, $modal, $timeout, ProposedLawNode,
    CodeLevel ) ->
    unless $scope.proposedLaw.workingRepoCreated
      return $state.transitionTo('proposedLaw.initialize',{proposedLawId: $scope.proposedLaw.id})
    onProposedLawNodeLoad = (proposedLawNode) ->
      $scope.proposedLawNode = proposedLawNode
      unless $scope.proposedLawNode.childNodesAllowed
        $state.go( 'proposedLaw.node',{
          proposedLawId: $stateParams.proposedLawId
          tree: $stateParams.tree } )
    onProposedLawNodesLoad = (proposedLawNodes) ->
      $scope.proposedLawNodes = proposedLawNodes
    ProposedLawNode.get( {
      proposedLawId: $scope.proposedLaw.id
      tree: $stateParams.tree }, onProposedLawNodeLoad )
    ProposedLawNode.query( {
      proposedLawId: $scope.proposedLaw.id
      tree: $stateParams.tree }, onProposedLawNodesLoad )
    $scope.editNode = (node) ->
      modalInstance = $modal.open(
        templateUrl: 'proposedLawNodeSettings/edit.html',
        controller: 'ProposedLawNodeSettingsCtrl',
        resolve:
          proposedLaw: ->
            $scope.proposedLaw
          proposedLawNode: ->
            node.proposedLawId = $scope.proposedLaw.id
            node.exists = true
            node
          parentNode: ->
            $scope.proposedLawNode
      )
      modalInstance.result.then(
        ( (proposedLawNode) ->
          $state.reload
        ),
        ( () -> false ) )
    $scope.newNode = (proposedLawNode,nodeType) ->
      modalInstance = $modal.open(
        templateUrl: 'proposedLawNodeSettings/new.html',
        controller: 'ProposedLawNodeSettingsCtrl',
        resolve:
          proposedLaw: ->
            $scope.proposedLaw
          proposedLawNode: ->
            node = new ProposedLawNode( {
              proposedLawId: $scope.proposedLaw.id } )
            node.nodeType = nodeType
            node.attributes = { }
            node.attributes.type = nodeType.label
            if proposedLawNode.tree == ''
              node.attributes.structure = [ new CodeLevel() ]
            node
          parentNode: ->
            proposedLawNode
      )
      modalInstance.result.then(
        ( (proposedLawNode) ->
          $state.go('.', { tree: proposedLawNode.tree })
        ),
        ( () -> false ) )
  ] )
