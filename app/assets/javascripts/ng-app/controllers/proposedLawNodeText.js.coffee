angular
  .module 'gitLaw'
  .controller( 'ProposedLawNodeTextCtrl', [ '$state', '$scope', '$stateParams',
  '$timeout', 'ProposedLawNode', 'ProposedLawFile',
  ( $state, $scope, $stateParams, $timeout, ProposedLawNode, ProposedLawFile ) ->
      unless $scope.proposedLaw.workingRepoCreated
        return $state.go('proposedLaw.initialize',{proposedLawId: $scope.proposedLaw.id})
      onProposedLawFileLoad = (proposedLawFile) ->
        $scope.proposedLawFile = proposedLawFile
        $scope.timeout = null
        saveContent = () ->
          success = (n,headers) ->
          fail = (n,headers) ->
          $scope.proposedLawFile.$save({},success,fail)
        cancelTimeout = ->
          $timeout.cancel( $scope.timeout ) if $scope.timeout
        debounceSaveContent = ( newVal, oldVal ) ->
          if newVal != oldVal
            cancelTimeout()
            $scope.timeout = $timeout( saveContent, 5000 )
        $scope.$on '$destroy', ->
          cancelTimeout()
        $scope.$watch('proposedLawFile.content', debounceSaveContent)
      onProposedLawNodeLoad = ( proposedLawNode ) ->
        $scope.proposedLawNode = proposedLawNode
        if !proposedLawNode.textFileTree && proposedLawNode.childNodesAllowed
          return $state.go( 'proposedLaw.nodes',{
            proposedLawId: $stateParams.proposedLawId
            tree: $stateParams.tree } )
        ProposedLawFile.get( {
          proposedLawId: proposedLawNode.proposedLawId
          tree: proposedLawNode.textFileTree }, onProposedLawFileLoad )
      $scope.setupEditor = ( editor ) ->
        editor.setOption('maxLines',100)
        editor.$blockscrolling = Infinity
      ProposedLawNode.get( {
          proposedLawId: $scope.proposedLaw.id
          tree: $stateParams.tree
        }, onProposedLawNodeLoad )
  ] )
