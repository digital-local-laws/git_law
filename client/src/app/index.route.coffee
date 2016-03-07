angular.module 'client'
  .config ($stateProvider, $urlRouterProvider, $urlMatcherFactoryProvider) ->
    'ngInject'
    # Define states of the application and map them to controllers
    $stateProvider
      .state 'home',
        url: '/'
        templateUrl: 'app/main/main.html'
        controller: 'MainController'
        controllerAs: 'main'
      .state 'signin', {
        url: '/sign-in'
        templateUrl: 'app/userSession/new.html'
        controller: 'UserSessionCtrl'
      }
      .state 'jurisdiction', {
        abstract: true
        url: '/jurisdictions/:jurisdictionId'
        resolve:
          jurisdiction: (Jurisdiction, $stateParams) ->
            Jurisdiction.get( {
              jurisdictionId: $stateParams.jurisdictionId
            } ).$promise
        templateUrl: 'app/jurisdiction/layout.html'
        controller: 'JurisdictionCtrl'
      }
      .state 'jurisdiction.edit', {
        url: '/edit'
        templateUrl: 'app/jurisdiction/edit.html'
        controller: 'JurisdictionSettingsCtrl'
      }
      .state 'jurisdiction.proposedLaws', {
        url: '/proposed-laws/page/:page'
        templateUrl: 'app/proposedLaws/proposedLaws.html'
        controller: 'ProposedLawsCtrl'
        controllerAs: 'ctrl'
      }
      .state 'jurisdiction.proposeLaw', {
        url: 'proposed-laws/new'
        templateUrl: 'app/proposedLaws/newProposedLawSettings.html'
        controller: 'ProposedLawSettingsCtrl'
        resolve:
          proposedLaw: ( proposedLawState, $stateParams ) ->
            proposedLawState($stateParams)
      }
      .state 'newJurisdiction', {
        url: '/new-jurisdiction'
        templateUrl: 'app/jurisdiction/new.html'
        controller: 'JurisdictionSettingsCtrl'
        resolve:
          jurisdiction: -> { }
      }
      .state 'jurisdictions', {
        url: '/jurisdictions/page/:page'
        templateUrl: 'app/jurisdictions/layout.html'
        controller: 'JurisdictionsCtrl'
      }
      .state 'proposedLaw', {
        abstract: true
        url: '/proposed-laws/:proposedLawId'
        resolve: {
          proposedLaw: (ProposedLaw, $stateParams) ->
            ProposedLaw.get( {
              proposedLawId: $stateParams.proposedLawId
            } ).$promise
        }
        templateUrl: 'app/proposedLaw/layout.html'
        controller: 'ProposedLawCtrl'
      }
      .state 'proposedLaw.initialize', {
        url: '/initialize'
        templateUrl: 'app/proposedLaw/initialize.html'
        controller: 'ProposedLawInitializeCtrl'
      }
      .state 'proposedLaw.edit', {
        url: '/edit'
        templateUrl: 'app/proposedLaws/editProposedLawSettings.html'
        controller: 'ProposedLawSettingsCtrl'
        resolve: {
          proposedLaw: ( proposedLawState, $stateParams ) ->
            proposedLawState($stateParams)
        }
      }
      .state 'proposedLaw.node', {
        url: '/node/*treeBase'
        resolve:
          proposedLawNode: ( proposedLawNodeState, $stateParams ) ->
            proposedLawNodeState $stateParams
        templateUrl: 'app/proposedLawNode/node.html'
        controller: 'ProposedLawNodeCtrl'
      }
      .state 'proposedLaw.editNode', {
        url: '/edit-node/*treeBase'
        resolve:
          proposedLawNode: ( proposedLawNodeState, $stateParams ) ->
            proposedLawNodeState $stateParams
        templateUrl: 'app/proposedLawNode/edit.html'
        controller: 'ProposedLawNodeSettingsCtrl'
      }
      .state 'proposedLaw.newNode', {
        url: '/new-node/:label/*treeBase'
        resolve:
          proposedLawNode: ( proposedLawNodeState, $stateParams ) ->
            proposedLawNodeState $stateParams
        templateUrl: 'app/proposedLawNode/new.html'
        controller: 'ProposedLawNodeSettingsCtrl'
      }
      .state 'proposedLaw.adopt', {
        url: '/adopt'
        templateUrl: 'app/proposedLaw/adopt.html'
        controller: 'AdoptLawCtrl'
      }
      .state 'adoptedLaw', {
        url: '/adoptedLaw/:adoptedLawId'
        resolve: {
          adoptedLaw: (AdoptedLaw, $stateParams) ->
            AdoptedLaw.get( {
              adoptedLawId: $stateParams.adoptedLawId
            } ).$promise
        }
        templateUrl: 'app/adoptedLaw/layout.html'
        controller: 'AdoptedLawCtrl'
      }
    # Provide additional routes to states
    $urlRouterProvider.when '/jurisdictions/:jurisdictionId',
      ( $match, $state ) ->
        $state.go 'jurisdiction.proposedLaws', {
          jurisdictionId: $match.jurisdictionId
          page: 1
        }
    $urlRouterProvider.when '/jurisdictions/:jurisdictionId/proposed-laws',
      ( $match, $state ) ->
        $state.go 'jurisdiction.proposedLaws', {
          jurisdictionId: $match.jurisdictionId
          page: 1
        }
    $urlRouterProvider.when '/proposed-laws/:proposedLawId',
      ( $match, $state ) ->
        $state.go 'proposedLaw.node', {
          proposedLawId: $match.proposedLawId
          treeBase: ''
        }
    $urlRouterProvider.otherwise '/'
