angular
  .module 'gitLaw'
  .controller( 'ProposedLawNodeSettingsCtrl', ['$scope', '$modalInstance',
  '$upload', 'proposedLawNode', 'ProposedLawNode', 'parentNode', 'lawNodeFilenameFilter',
  'CodeLevel'
  ( $scope, $modalInstance, $upload, proposedLawNode, ProposedLawNode, parentNode,
  lawNodeFilenameFilter, CodeLevel ) ->
    $scope.alerts = [ ]
    $scope.errors = { }
    $scope.proposedLawNode = proposedLawNode
    $scope.parentNode = parentNode
    $scope.types = [ ]
    $scope.types.push [ 'dir', 'Container' ] if parentNode.dir
    $scope.types.push [ '', 'Text' ] if parentNode.file
    $scope.setType = (type) ->
      $scope.proposedLawNode.type = type
    $scope.setType( $scope.types[0][0] ) if $scope.types.length == 1
    $scope.$watchCollection('[proposedLawNode.metadata.title, proposedLawNode.metadata.number]',
    (newVal,oldVal) ->
      $scope.proposedLawNode.fileName = lawNodeFilenameFilter(
        $scope.proposedLawNode, $scope.parentNode ) )
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
    $scope.optionalOptions = [
      [ true, "Is Optional" ]
      [ false, "Is Not Optional" ]
    ]
    $scope.setTitle = ( i, value ) ->
      $scope.proposedLawNode.metadata.structure[i].title = value
    $scope.setOptional = ( i, value ) ->
      $scope.proposedLawNode.metadata.structure[i].optional = value
    $scope.addLevel = ( i ) ->
      $scope.proposedLawNode.metadata.structure.splice i, 0, new CodeLevel()
    $scope.removeLevel = ( i ) ->
      $scope.proposedLawNode.metadata.structure.splice i, 1
    $scope.save = (proposedLawNode) ->
      success = ( proposedLawNode ) ->
        $modalInstance.close proposedLawNode
      failure = ( response ) ->
        $scope.alerts.push( { type: 'danger', msg: "Save failed." } )
        $scope.errors = response.data.errors
      if proposedLawNode.id
        proposedLawNode.$save( success, failure )
      else
        proposedLawNode.tree = if parentNode.ancestors.length > 1
          parentNode.tree + "/" + proposedLawNode.fileName
        else
          proposedLawNode.fileName
        ProposedLawNode.create( proposedLawNode, success, failure )
    $scope.cancel = ->
      $modalInstance.dismiss()
  ])
