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
        resolve: {
          jurisdiction: (Jurisdiction, $stateParams) ->
            Jurisdiction.get( {
              jurisdictionId: $stateParams.jurisdictionId
            } ).$promise
        }
        templateUrl: 'app/jurisdiction/layout.html'
        controller: 'JurisdictionCtrl'
      }
      .state 'jurisdiction.proposedLaws', {
        url: '/proposed-laws/page/:page'
        templateUrl: 'app/proposedLaws/proposedLaws.html'
        controller: 'ProposedLawsCtrl'
        controllerAs: 'ctrl'
      }
      .state 'jurisdiction.proposeLaw', {
        url: 'proposed-laws/new'
        templateUrl: 'app/proposedLawSettings/new.html'
        controller: 'ProposedLawSettingsCtrl'
        resolve:
          proposedLaw: ( proposedLawState, $stateParams ) ->
            proposedLawState($stateParams)
      }
      .state 'jurisdictions', {
        abstract: true
        url: '/jurisdictions'
        templateUrl: 'app/jurisdictions/layout.html'
        controller: 'JurisdictionsCtrl'
      }
      .state 'jurisdictions.one', {
        url: '',
        templateUrl: 'app/jurisdictions/list.html',
        controller: 'JurisdictionsListCtrl'
      }
      .state 'jurisdictions.paginated', {
        url: '/page/:page'
        templateUrl: 'app/jurisdictions/list.html'
        controller: 'JurisdictionsListCtrl'
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
        templateUrl: 'app/proposedLawSettings/edit.html'
        controller: 'ProposedLawSettingsCtrl'
        resolve: {
          proposedLaw: ( proposedLawState, $stateParams ) ->
            proposedLawState($stateParams)
        }
      }
      .state 'proposedLaw.node', {
        url: '/node/*treeBase'
        resolve:
          proposedLawNode: (ProposedLawNode, $stateParams) ->
            ProposedLawNode.get( {
              proposedLawId: $stateParams.proposedLawId
              treeBase: $stateParams.treeBase } ).$promise
        templateUrl: 'app/proposedLawNode/node.html'
        controller: 'ProposedLawNodeCtrl'
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
      #  '/#/jurisdictions/:jurisdictionId/proposed-laws')

    $urlRouterProvider.when '/jurisdictions/:jurisdictionId/proposed-laws',
      ( $match, $state ) ->
        $state.go 'jurisdiction.proposedLaws', {
          jurisdictionId: $match.jurisdictionId
          page: 1
        }
      # '/#/jurisdictions/:jurisdictionId/proposed-laws/page/1')
    $urlRouterProvider.when '/proposed-laws/:proposedLawId',
      ( $match, $state ) ->
        $state.go 'proposedLaw.node', {
          proposedLawId: $match.proposedLawId
          treeBase: ''
        }
      # '/#/proposed-laws/:proposedLawId/node/')
    # $urlRouterProvider.when '/proposed-laws/:proposedLawId/node',
    #   ( $match, $state ) ->
    #     $state.transitionTo 'proposedLaw.node', {
    #       proposedLawId: $match.proposedLawId
    #       treeBase: ''
    #     }
      # '/#/proposed-laws/:proposedLawId/node/')
    $urlRouterProvider.otherwise '/'
    # $urlMatcherFactoryProvider
    #   .type 'path', {
    #     is: (val) ->
    #       true
    #     decode: (val) ->
    #       val || ""
    #     encode: (val) ->
    #       val || ""
    #   }
