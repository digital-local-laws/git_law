angular
  .module 'gitLaw', [ 'angularFileUpload', 'ngAnimate', 'ngSanitize',
     'ui.select', 'ui.router', 'ngResource', 'templates', 'ui.utils',
    'ui.bootstrap', 'angular-chartist', 'ui.tree', 'lawNodeFilters',
    'ui.ace', 'glFileContentDirective', 'glNodeLocationDirective' ]
  .config ($stateProvider, $urlRouterProvider, $locationProvider,
    $urlMatcherFactoryProvider, uiSelectConfig ) ->
    uiSelectConfig.theme = 'bootstrap'
    $urlRouterProvider.when('/jurisdictions/:jurisdictionId',
      '/jurisdictions/:jurisdictionId/proposed-laws')
    $urlRouterProvider.when('/jurisdictions/:jurisdictionId/proposed-laws',
      '/jurisdictions/:jurisdictionId/proposed-laws/page/1')
    $urlRouterProvider.when('/proposed-laws/:proposedLawId',
      '/proposed-laws/:proposedLawId/node/')
    $urlRouterProvider.when('/proposed-laws/:proposedLawId/node',
      '/proposed-laws/:proposedLawId/node/')
    $urlMatcherFactoryProvider
      .type('path', {
        is: (val) ->
          true
        decode: (val) ->
          val || ""
        encode: (val) ->
          val || ""
      } )
    $stateProvider
      .state 'home', {
        url: '/',
        views:
          "navigation":
            templateUrl: 'navbar.html'
            controller: 'NavigationCtrl'
          "content":
            templateUrl: 'home.html'
            controller: 'HomeCtrl'
      }
      .state 'signin', {
        url: '/sign-in',
        views:
          "navigation":
            templateUrl: 'navbar.html'
            controller: 'NavigationCtrl'
          "content":
            templateUrl: 'userSession/new.html'
            controller: 'UserSessionCtrl'
      }
      .state 'jurisdiction', {
        abstract: true,
        url: '/jurisdictions/:jurisdictionId',
        views:
          "navigation":
            templateUrl: 'navbar.html'
            controller: 'NavigationCtrl'
          "content":
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
        abstract: true,
        url: '/jurisdictions',
        views:
          "navigation":
            templateUrl: 'navbar.html'
            controller: 'NavigationCtrl'
          "content":
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
        views:
          "navigation":
            templateUrl: 'navbar.html'
            controller: 'NavigationCtrl'
          "content":
            templateUrl: 'proposedLaw/layout.html'
            controller: 'ProposedLawCtrl'
      }
      .state 'proposedLaw.initialize', {
        url: '/initialize'
        templateUrl: 'proposedLaw/initialize.html'
        controller: 'ProposedLawInitializeCtrl'
      }
      .state 'proposedLaw.node', {
        url: '/node/{tree:path}'
        templateUrl: 'proposedLawNode/node.html'
        controller: 'ProposedLawNodeCtrl'
      }
    $urlRouterProvider.otherwise '/'
    $locationProvider.html5Mode true
