angular.module 'client'
  .controller 'ProposedLawNodeCtrl', ( $state, $scope, $stateParams,
    ProposedLawNode, Flash, proposedLawNode ) ->
      unless $scope.proposedLaw.workingRepoCreated
        return $state.go( 'proposedLaw.initialize',
          { proposedLawId: $scope.proposedLaw.id }
        )
      onProposedLawNodesLoad = (proposedLawNodes) ->
        $scope.proposedLawNodes = proposedLawNodes
      onProposedLawNodeLoad = (proposedLawNode) ->
        $scope.proposedLawNode = angular.copy proposedLawNode
        $scope.setupEditor = ( editor ) ->
          editor.setOption('maxLines',100)
          editor.$blockScrolling = Infinity
        $scope.saveContent = (content,callback=false) ->
          success = (resp) ->
            callback() if callback
          fail = (err) ->
            Flash.create 'danger', 'Save failed.'
            callback() if callback
          proposedLawNode.text = content
          proposedLawNode.$saveText({},success,fail)
        if proposedLawNode.childNodesAllowed
          ProposedLawNode.query( {
            proposedLawId: $scope.proposedLaw.id
            treeBase: $stateParams.treeBase }, onProposedLawNodesLoad )
      onProposedLawNodeLoad proposedLawNode
      $scope.removeNode = (node) ->
        success = (response) ->
          Flash.create( 'info', 'Node was removed.' )
          $state.reload()
        node.$delete( { proposedLawId: $scope.proposedLaw.id }, success )
      $scope.editNode = (node) ->
        $state.go '^.editNode', { treeBase: node.treeBase }
      $scope.newNode = (node,nodeType) ->
        $state.go '^.newNode', { treeBase: node.treeBase, label: nodeType.label }
