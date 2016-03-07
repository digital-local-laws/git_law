angular.module 'client'
  .controller 'ProposedLawNodeSettingsCtrl', ( $scope, $state, proposedLawNode,
    ProposedLawNode, lawNodeFilenameBaseFilter, CodeLevel,
    Flash, $stateParams, proposedLaw, $log ) ->
      $scope.errors = { }
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
      $scope.$watchCollection('[proposedLawNode.attributes.title, proposedLawNode.attributes.number]',
      (newVal,oldVal) ->
        $scope.proposedLawNode.fileNameBase = lawNodeFilenameBaseFilter(
          $scope.proposedLawNode ) )
      $scope.numberOptions = [
        [ "1", "Arabic (1, 2, ...)", "1" ]
        [ "R", "Upper case roman (I, II, ...)", "I" ]
        [ "r", "Lower case roman (i, ii, ...)", "i" ]
        [ "A", "Upper case alphabetical (A, B, ...)", "A" ]
        [ "a", "Lower case alphabetical (a, b, ...)", "a" ]
      ]
      $scope.titleOptions = [
        [ true, "Allow Title" ]
        [ false, "Prohibit Title" ]
      ]
      $scope.textOptions = [
        [ true, "Allow Text" ]
        [ false, "Prohibit Text" ]
      ]
      $scope.optionalOptions = [
        [ true, "Is Optional" ]
        [ false, "Is Not Optional" ]
      ]
      $scope.setTitle = ( i, value ) ->
        $scope.proposedLawNode.attributes.structure[i].title = value
      $scope.setOptional = ( i, value ) ->
        $scope.proposedLawNode.attributes.structure[i].optional = value
      $scope.setText = ( i, value ) ->
        $scope.proposedLawNode.attributes.structure[i].text = value
      $scope.addLevel = ( i ) ->
        $scope.proposedLawNode.attributes.structure.splice i, 0, new CodeLevel()
      $scope.removeLevel = ( i ) ->
        $scope.proposedLawNode.attributes.structure.splice i, 1
      $scope.save = () ->
        message = ''
        onCreate = ( proposedLawNode ) ->
          Flash.create 'success', 'New node created'
          $state.go '^.node', { treeBase: proposedLawNode.treeBase }
        onUpdate = ( proposedLawNode ) ->
          Flash.create 'success', 'Node settings updated'
          $state.go '^.node', { treeBase: $scope.parentNode.treeBase }
        failure = ( response ) ->
          Flash.create( 'danger', 'Save failed.' )
          $scope.errors = response.data.errors
        if $scope.proposedLawNode.exists
          toTreeBase = if $scope.parentNode.treeBase == ""
            $scope.proposedLawNode.fileNameBase
          else
            $scope.parentNode.treeBase + "/" + $scope.proposedLawNode.fileNameBase
          params = if toTreeBase != $scope.proposedLawNode.treeBase
            { toTreeBase: toTreeBase }
          else
            { }
          $scope.proposedLawNode.$save( params, onUpdate, failure )
        else
          $scope.proposedLawNode.treeBase = if $scope.parentNode.treeBase
            $scope.parentNode.treeBase + "/" + $scope.proposedLawNode.fileNameBase
          else
            $scope.proposedLawNode.fileNameBase
          ProposedLawNode.create( $scope.proposedLawNode, onCreate, failure )
      $scope.cancel = ->
        $state.go '^.node', { treeBase: $scope.parentNode.treeBase }
