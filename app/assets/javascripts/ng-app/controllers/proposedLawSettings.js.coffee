angular
  .module 'gitLaw'
  .controller( 'ProposedLawSettingsCtrl', ['$scope', '$uibModalInstance',
  '$upload', 'proposedLaw', 'ProposedLaw', 'jurisdiction'
  ( $scope, $uibModalInstance, $upload, proposedLaw, ProposedLaw, jurisdiction ) ->
    $scope.alerts = [ ]
    $scope.errors = { }
    $scope.jurisdiction = jurisdiction
    $scope.proposedLaw = proposedLaw
    $scope.save = (proposedLaw) ->
      success = ( proposedLaw ) ->
        $uibModalInstance.close proposedLaw
      failure = ( response ) ->
        $scope.alerts.push( { type: 'danger', msg: "Save failed." } )
        $scope.errors = response.data.errors
      if proposedLaw.id
        proposedLaw.$save( success, failure )
      else
        ProposedLaw.create( proposedLaw, success, failure )
    $scope.cancel = ->
      $uibModalInstance.dismiss()
  ])
