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
    $scope.$watchCollection('[proposedLawNode.attributes.title, proposedLawNode.attributes.number]',
    (newVal,oldVal) ->
      $scope.proposedLawNode.fileName = lawNodeFilenameFilter(
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
      success = ( proposedLawNode ) ->
        $modalInstance.close proposedLawNode
      failure = ( response ) ->
        $scope.alerts.push( { type: 'danger', msg: "Save failed." } )
        $scope.errors = response.data.errors
      if proposedLawNode.exists
        toTree = parentNode.treeBase + "/" + proposedLawNode.fileName
        params = if toTree != proposedLawNode.tree
          { toTree: toTree }
        else
          { }
        proposedLawNode.$save( params, success, failure )
      else
        proposedLawNode.tree = if parentNode.tree
          parentNode.treeBase + "/" + proposedLawNode.fileName
        else
          proposedLawNode.fileName
        ProposedLawNode.create( proposedLawNode, success, failure )
    $scope.cancel = ->
      $modalInstance.dismiss()
  ])
