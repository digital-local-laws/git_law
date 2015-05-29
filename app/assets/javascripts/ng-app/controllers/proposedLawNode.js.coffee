angular
  .module 'gitLaw'
  .controller( 'ProposedLawNodeCtrl', [ '$state', '$scope', '$stateParams',
  '$modal', '$timeout', 'ProposedLawNode', 'CodeLevel'
  ( $state, $scope, $stateParams, $modal, $timeout, ProposedLawNode,
    CodeLevel ) ->
    unless $scope.proposedLaw.workingRepoCreated
      return $state.go('^.initialize')
    onProposedLawNodeLoad = (proposedLawNode) ->
      $scope.proposedLawNode = proposedLawNode
      timeout = null
      saveContent = () ->
        success = (n,headers) ->
        fail = (n,headers) ->
        $scope.proposedLawNode.$save({},success,fail)
      debounceSaveContent = ( newVal, oldVal ) ->
        if newVal != oldVal
          $timeout.cancel( timeout ) if timeout
          timeout = $timeout( saveContent, 5000 )
      $scope.$watch('proposedLawNode.content', debounceSaveContent)
    ProposedLawNode.get( {
      proposedLawId: $scope.proposedLaw.id
      tree: $stateParams.tree }, onProposedLawNodeLoad )
    $scope.heightUpdate = (editor) ->
      editor.setOption('maxLines',100)
    $scope.newNode = (proposedLawNode) ->
      modalInstance = $modal.open( {
        templateUrl: 'proposedLawNodeSettings/new.html',
        controller: 'ProposedLawNodeSettingsCtrl',
        resolve: {
          proposedLaw: ( -> $scope.proposedLaw )
          proposedLawNode: ( ->
            node = new ProposedLawNode( {
              proposedLawId: $scope.proposedLaw.id } )
            if proposedLawNode.ancestors.length == 1
              node.metadata = {
                structure: [ new CodeLevel() ]
              }
            else
              node.metadata = { }
            node
          )
          parentNode: ( -> proposedLawNode ) } } )
      modalInstance.result.then(
        ( (proposedLawNode) ->
          $state.go('.', { tree: proposedLawNode.tree })
        ),
        ( () -> false ) )
    $scope.editorMode = (node) ->
      switch node.type
        when '.json' then 'json'
        when 'dir'
          throw 'Editor does not support directory type.'
        else 'asciidoc'
  ] )
