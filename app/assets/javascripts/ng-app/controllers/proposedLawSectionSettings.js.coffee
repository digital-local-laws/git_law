angular
  .module 'gitLaw'
  .controller( 'ProposedLawSectionSettingsCtrl', ['$scope', '$modalInstance',
  '$upload', 'proposedLawSection', 'ProposedLawSection',
  ( $scope, $modalInstance, $upload, proposedLawSection, ProposedLawSection ) ->
    $scope.alerts = [ ]
    $scope.errors = { }
    $scope.actions = [
      [ 'add', 'Add' ]
      [ 'repeal', 'Repeal' ]
      [ 'replace', 'Replace' ]
    ]
    $scope.contentTypes = [
      [ 'uncodified','Uncodified Laws' ]
    ]
    $scope.proposedLawSection = proposedLawSection
    $scope.save = (proposedLawSection) ->
      success = ( proposedLawSection ) ->
        $modalInstance.close proposedLawSection
      failure = ( response ) ->
        $scope.alerts.push( { type: 'danger', msg: "Save failed." } )
        $scope.errors = response.data.errors
      if proposedLawSection.id
        proposedLawSection.$save( success, failure )
      else
        ProposedLawSection.create( proposedLawSection, success, failure )
    $scope.cancel = ->
      $modalInstance.dismiss()
  ])
