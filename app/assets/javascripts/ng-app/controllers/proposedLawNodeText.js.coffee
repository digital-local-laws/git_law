angular
  .module 'gitLaw'
  .controller( 'ProposedLawNodeTextCtrl', [ '$state', '$scope', '$stateParams',
  '$modal', '$timeout', 'ProposedLawFile'
  ( $state, $scope, $stateParams, $modal, $timeout, ProposedLawNode,
    CodeLevel ) ->
    unless $scope.proposedLaw.workingRepoCreated
      return $state.transitionTo('proposedLaw.initialize',{proposedLawId: $scope.proposedLaw.id})
    onProposedLawFileLoad = (proposedLawNode) ->
      $scope.proposedLawFile = proposedLawFile
      timeout = null
      saveContent = () ->
        success = (n,headers) ->
        fail = (n,headers) ->
        $scope.proposedLawNode.$save({},success,fail)
      cancelTimeout = ->
        $timeout.cancel( timeout ) if timeout
      debounceSaveContent = ( newVal, oldVal ) ->
        if newVal != oldVal
          cancelTimeout
          timeout = $timeout( saveContent, 5000 )
      $scope.$on '$destroy', ->
        cancelTimeout()
      $scope.$watch('proposedLawFile.content', debounceSaveContent)
    ProposedLawFile.get( {
      proposedLawId: $scope.proposedLaw.id
      tree: $stateParams.tree }, onProposedLawFileLoad )
    $scope.heightUpdate = (editor) ->
      editor.setOption('maxLines',100)
  ] )
