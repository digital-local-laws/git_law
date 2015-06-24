angular
  .module 'gitLaw'
  .controller( 'ProposedLawNodeCtrl', [ '$state', '$scope', '$stateParams',
  '$modal', '$timeout', 'ProposedLawNode', 'ProposedLawFile', 'CodeLevel',
  ( $state, $scope, $stateParams, $modal, $timeout, ProposedLawNode,
    ProposedLawFile, CodeLevel ) ->
    unless $scope.proposedLaw.workingRepoCreated
      return $state.transitionTo( 'proposedLaw.initialize',
        { proposedLawId: $scope.proposedLaw.id }
      )
    $scope.alerts = []
    onProposedLawFileLoad = (proposedLawFile) ->
      $scope.proposedLawFile = proposedLawFile
      $scope.noProposedLawFile = false
      $scope.timeout = null
      saveContent = () ->
        success = (n,headers) ->
        fail = (n,headers) ->
        $scope.proposedLawFile.$save({},success,fail)
        $scope.saveInProgress = false
      cancelTimeout = ->
        $timeout.cancel( $scope.timeout ) if $scope.timeout
      debounceSaveContent = ( newVal, oldVal ) ->
        if newVal != oldVal
          $scope.saveInProgress = true
          cancelTimeout()
          $scope.timeout = $timeout( saveContent, 5000 )
      $scope.$on '$destroy', ->
        cancelTimeout()
      $scope.$watch('proposedLawFile.content', debounceSaveContent)
    onProposedLawFileFail = ( response ) ->
      if response.status == 404
        $scope.noProposedLawFile = true
    $scope.createProposedLawFile = () ->
      ProposedLawFile.create( {
          proposedLawId: $scope.proposedLaw.id
          tree: $scope.proposedLawNode.textFileTree
        }, onProposedLawFileLoad
      )
    onProposedLawNodesLoad = (proposedLawNodes) ->
      $scope.proposedLawNodes = proposedLawNodes
    onProposedLawNodeLoad = (proposedLawNode) ->
      $scope.proposedLawNode = proposedLawNode
      if proposedLawNode.nodeType.text
        ProposedLawFile.get( {
          proposedLawId: proposedLawNode.proposedLawId
          tree: proposedLawNode.textFileTree }, onProposedLawFileLoad,
          onProposedLawFileFail )
      if proposedLawNode.childNodesAllowed
        ProposedLawNode.query( {
          proposedLawId: $scope.proposedLaw.id
          treeBase: $stateParams.treeBase }, onProposedLawNodesLoad )
    ProposedLawNode.get( {
      proposedLawId: $scope.proposedLaw.id
      treeBase: $stateParams.treeBase }, onProposedLawNodeLoad )
    $scope.setupEditor = ( editor ) ->
      editor.setOption('maxLines',100)
      editor.$blockscrolling = Infinity
    $scope.removeNode = (node) ->
      success = (response) ->
        $scope.alerts.push [ "info", "Node was removed." ]
        $scope.proposedLawNodes.splice $scope.proposedLawNodes.indexOf(node), 1
      node.$delete( { proposedLawId: $scope.proposedLaw.id }, success )
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
          $state.reload()
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
            if proposedLawNode.treeBase == ''
              node.attributes.structure = [ new CodeLevel() ]
            node
          parentNode: ->
            proposedLawNode
      )
      modalInstance.result.then(
        ( (proposedLawNode) ->
          $state.go('.', { treeBase: proposedLawNode.treeBase })
        ),
        ( () -> false ) )
  ] )
