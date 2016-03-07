angular.module 'client'
  .controller 'ProposedLawNodeSettingsCtrl', ( $scope, CodeLevel,
    proposedLawNode, $stateParams ) ->
      # Setup for new node
      if $stateParams.label
        $scope.parentNode = proposedLawNode
        nodeType = ( type for type in proposedLawNode.allowedChildNodeTypes when type.label == $stateParams.label )[0]
        unless nodeType
          throw new Exception 'Invalid label for child node: ' + $stateParams.label
        $scope.proposedLawNode = {
          proposedLawId: proposedLawNode.proposedLawId
          nodeType: nodeType
          attributes:
            type: nodeType.label
        }
        if proposedLawNode.treeBase == ''
          $scope.proposedLawNode.attributes.structure = [ new CodeLevel() ]
        $scope.proposedLawNode.exists = false
      # Setup for existing node
      else
        $scope.proposedLawNode = proposedLawNode
        $scope.proposedLawNode.exists = true
        $scope.parentNode = if proposedLawNode.ancestorNodes.length > 1
          proposedLawNode
            .ancestorNodes[ proposedLawNode.ancestorNodes.length - 2 ]
        else
          false
