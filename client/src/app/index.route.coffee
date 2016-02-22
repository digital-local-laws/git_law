angular.module 'client'
  .config ($stateProvider, $urlRouterProvider) ->
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
        templateUrl: 'userSession/new.html'
        controller: 'UserSessionCtrl'
      }
      .state 'jurisdiction', {
        abstract: true
        url: '/jurisdictions/:jurisdictionId'
        templateUrl: 'jurisdiction/layout.html'
        controller: 'JurisdictionCtrl'
      }
      .state 'jurisdiction.proposedLaws', {
        abstract: true,
        url: '/proposed-laws',
        views:
          "pane":
            templateUrl: 'proposedLaws/proposedLaws.html'
            controller: 'ProposedLawsCtrl'
      }
      .state 'jurisdiction.proposedLaws.paginated', {
        url: '/page/:page'
        templateUrl: 'proposedLaws/proposedLawsList.html'
        controller: 'ProposedLawsListCtrl'
      }
      .state 'jurisdictions', {
        abstract: true
        url: '/jurisdictions'
        templateUrl: 'jurisdictions/layout.html'
        controller: 'JurisdictionsCtrl'
      }
      .state 'jurisdictions.one', {
        url: '',
        templateUrl: 'jurisdictions/list.html',
        controller: 'JurisdictionsListCtrl'
      }
      .state 'jurisdictions.paginated', {
        url: '/page/:page'
        templateUrl: 'jurisdictions/list.html'
        controller: 'JurisdictionsListCtrl'
      }
      .state 'proposedLaw', {
        abstract: true
        url: '/proposed-laws/:proposedLawId'
        resolve: {
          proposedLaw: (ProposedLaw, $stateParams) ->
            ProposedLaw.get({proposedLawId: $stateParams.proposedLawId}).$promise
        }
        templateUrl: 'proposedLaw/layout.html'
        controller: 'ProposedLawCtrl'
      }
      .state 'proposedLaw.initialize', {
        url: '/initialize'
        templateUrl: 'proposedLaw/initialize.html'
        controller: 'ProposedLawInitializeCtrl'
      }
      .state 'proposedLaw.node', {
        url: '/node/{treeBase:path}'
        templateUrl: 'proposedLawNode/node.html'
        controller: 'ProposedLawNodeCtrl'
      }
      .state 'proposedLaw.adopt', {
        url: '/adopt'
        templateUrl: 'proposedLaw/adopt.html'
        controller: 'AdoptLawCtrl'
      }
      .state 'adoptedLaw', {
        url: '/adoptedLaw'
        templateUrl: 'adoptedLaw/layout.html'
        controller: 'AdoptedLawCtrl'
      }
    # Provide additional routes to states
    $urlRouterProvider.when('/jurisdictions/:jurisdictionId',
      '/jurisdictions/:jurisdictionId/proposed-laws')
    $urlRouterProvider.when('/jurisdictions/:jurisdictionId/proposed-laws',
      '/jurisdictions/:jurisdictionId/proposed-laws/page/1')
    $urlRouterProvider.when('/proposed-laws/:proposedLawId',
      '/proposed-laws/:proposedLawId/node/')
    $urlRouterProvider.when('/proposed-laws/:proposedLawId/node',
      '/proposed-laws/:proposedLawId/node/')
    # $urlMatcherFactoryProvider
    #   .type('path', {
    #     is: (val) ->
    #       true
    #     decode: (val) ->
    #       val || ""
    #     encode: (val) ->
    #       val || ""
    #   } )
    $urlRouterProvider.otherwise '/'
