angular
  .module 'gitLaw', [ 'angularFileUpload', 'ngAnimate', 'ngSanitize', 'ui.select', 'ui.router',
    'ngResource', 'templates', 'ui.utils',
    'ui.bootstrap', 'angular-chartist' ]
  .config ($stateProvider, $urlRouterProvider, $locationProvider,
    uiSelectConfig ) ->
    uiSelectConfig.theme = 'bootstrap'
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
      .state 'jurisdiction.proposed', {
        abstract: true,
        url: '',
        views:
          "pane":
            templateUrl: 'jurisdiction/proposed.html'
            controller: 'ProposedLawsCtrl'
      }
      .state 'jurisdiction.proposed.one', {
        url: '',
        templateUrl: 'jurisdiction/proposedList.html',
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
    $urlRouterProvider.otherwise '/'
    $locationProvider.html5Mode true
