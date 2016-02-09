angular
  .module 'gitLaw'
  .controller( 'AdoptLawCtrl', ['$scope', '$state', '$stateParams',
  'AdoptedLaw', 'Flash',
  ( $scope, $state, $stateParams, AdoptedLaw, Flash ) ->
    $scope.alerts = [ ]
    $scope.errors = { }
    $scope.certificationOptions = [
      [ '1', 'Local legislative body only' ]
      [ '2', 'Local legislative body with approval, no approval, or ' +
             'repassage after disapproval by elective Chief Executive Officer' ]
      [ '3', 'Referendum' ]
      [ '4', 'Permissive referendum and final adoption because no valid ' +
             'petition was filed requesting referendum' ]
      [ '5', 'City local law concerning Charter revision proposed by petition' ]
      [ '6', 'County local law concerning adoption of Charter' ]
      [ '7', 'Other (write your own certification)' ]
    ]
    $scope.adoptedLaw = new AdoptedLaw( { proposedLawId: $stateParams.proposedLawId } )
    $scope.save = (adoptedLaw) ->
      success = ( adoptedLaw ) ->
        Flash.create( 'success', 'Adopted law was submitted.')
        $state.go( 'adoptedLaw', { adoptedLawId: adoptedLaw.id } )
      failure = ( response ) ->
        $scope.alerts.push( { type: 'danger', msg: "Adopt failed." } )
        $scope.errors = response.data.errors
      AdoptedLaw.create( adoptedLaw, success, failure )
    $scope.cancel = ->
      $state.go( '^.node' )
  ])
