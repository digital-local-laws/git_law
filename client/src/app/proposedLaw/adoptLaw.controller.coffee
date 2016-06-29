angular.module 'client'
  .controller 'AdoptLawCtrl', ( $scope, $state, $stateParams, AdoptedLaw,
    Flash, $log, $filter ) ->
      $scope.alerts = [ ]
      $scope.errors = { }
      # was ... by the executive officer
      $scope.executiveActionOptions = [
        [ 'approved', 'approved' ]
        [ 'allowed', 'not approved and no longer subject to approval' ]
        [ 'rejected', 'repassed after disapproval' ]
      ]
      # subject to ... referendum
      $scope.referendumTypeOptions = [
        [ 'mandatory', 'mandatory' ]
        [ 'permissive', 'permissive' ]
        [ 'city charter revision', 'city charter revision', 'sections (36)(37) of Municipal Home Rule Law' ]
        [ 'county charter adoption', 'county charter adoption', 'subdivisions (5)(7) of section 33 of Municipal Home Rule Law' ]
      ]
      # at the ... election
      $scope.electionTypeOptions = [
        [ 'general', 'general' ]
        [ 'special', 'special' ]
        [ 'annual', 'annual' ]
      ]
      $scope.adoptedLaw = new AdoptedLaw( { proposedLawId: $stateParams.proposedLawId } )
      $scope.certification = ( adoptedLaw ) ->
        text = ''
        if adoptedLaw.executiveAction
          text += 'Law was ' + $scope.executiveActionOptions[adoptedLaw.executiveAction][1] + ' by elected executive '
          text += 'on ' + $filter('date')($scope.adoptedLaw.executiveActionDate,'longDate') + '.'
        if adoptedLaw.referendumRequired && adoptedLaw.referendumType
          text += ' Law was subject to ' + $scope.referendumTypeOptions[adoptedLaw.referendumType][1] + 'referendum '
          if $scope.referendumTypeOptions[adoptedLaw.referendumType][2]
            text += 'pursuant to ' + $scope.referendumTypeOptions[adoptedLaw.referendumType][1] + ' '
          if adoptedLaw.electionType
            text += 'and was adopted in a ' + $scope.electionTypeOptions[adoptedLaw.electionType][1] + 'election held '
          else
            text += 'and no valid petition was received '
          if adoptedLaw.referendumDate
            text += 'on ' + $filter('date')($scope.adoptedLaw.referendumDate,'longDate') + '.'
        $scope.certificationText = text
      # $scope.$watchCollection 'adoptedLaw', () ->
      #   $scope.certification( $scope.adoptedLaw )
      $scope.save = (adoptedLaw) ->
        success = ( adoptedLaw ) ->
          Flash.create 'success', 'Adopted law was submitted.'
          $state.go( 'adoptedLaw', { adoptedLawId: adoptedLaw.id } )
        failure = ( response ) ->
          $scope.alerts.push( { type: 'danger', msg: "Adopt failed." } )
          $scope.errors = response.data.errors
        AdoptedLaw.create( adoptedLaw, success, failure )
      $scope.cancel = ->
        $state.go( '^.node' )
