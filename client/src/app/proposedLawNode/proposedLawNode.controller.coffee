angular.module 'client'
  .controller 'ProposedLawNodeCtrl', ( $state, $scope, $stateParams,
    $timeout, ProposedLawNode, ProposedLawFile, CodeLevel, Flash,
    proposedLawNode ) ->
      unless $scope.proposedLaw.workingRepoCreated
        return $state.go( 'proposedLaw.initialize',
          { proposedLawId: $scope.proposedLaw.id }
        )
      onProposedLawFileLoad = (proposedLawFile) ->
        $scope.proposedLawFile = proposedLawFile
        timeout = null
        saveContent = () ->
          success = (resp) ->
            $scope.saveInProgress = false
          fail = (err) ->
            Flash.create 'danger', 'Save failed.'
            $scope.saveInProgress = false
          $scope.proposedLawFile.$save({},success,fail)
        cancelTimeout = ->
          $timeout.cancel( timeout ) if timeout
        # Call this when file content changes
        # It will decide whether to save
        debounceSaveContent = ( newVal, oldVal ) ->
          return if $scope.saveInProgress
          if newVal != oldVal
            $scope.saveInProgress = true
            cancelTimeout()
            timeout = $timeout( saveContent, 5000 )
        $scope.$on '$destroy', ->
          cancelTimeout()
        $scope.$watch 'proposedLawFile.content', debounceSaveContent
      $scope.createProposedLawFile = () ->
        ProposedLawFile.create(
          {
            proposedLawId: $scope.proposedLaw.id
            tree: $scope.proposedLawNode.textFileTree
          }
          onProposedLawFileLoad
        )
      onProposedLawNodesLoad = (proposedLawNodes) ->
        $scope.proposedLawNodes = proposedLawNodes
      onProposedLawNodeLoad = (proposedLawNode) ->
        $scope.proposedLawNode = proposedLawNode
        if proposedLawNode.nodeType.text
          ProposedLawFile.get( {
            proposedLawId: proposedLawNode.proposedLawId
            tree: proposedLawNode.textFileTree }, onProposedLawFileLoad )
        if proposedLawNode.childNodesAllowed
          ProposedLawNode.query( {
            proposedLawId: $scope.proposedLaw.id
            treeBase: $stateParams.treeBase }, onProposedLawNodesLoad )
      onProposedLawNodeLoad proposedLawNode
      $scope.setupEditor = ( editor ) ->
        editor.setOption('maxLines',100)
        editor.$blockscrolling = Infinity
      $scope.removeNode = (node) ->
        success = (response) ->
          Flash.create( 'info', 'Node was removed.' )
          $state.reload()
        node.$delete( { proposedLawId: $scope.proposedLaw.id }, success )
      $scope.editNode = (node) ->
        $state.go '^.editNode', { treeBase: node.treeBase }
      $scope.newNode = (node,nodeType) ->
        $state.go '^.newNode', { treeBase: node.treeBase, label: nodeType.label }
