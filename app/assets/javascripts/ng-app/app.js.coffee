angular
  .module 'gitLaw', [ 'angularFileUpload', 'ngAnimate', 'ngSanitize',
     'ui.select', 'ui.router', 'ngResource', 'templates', 'ui.utils',
    'ui.bootstrap', 'angular-chartist', 'ui.tree', 'lawNodeFilters',
    'ui.ace' ]
  .config ($stateProvider, $urlRouterProvider, $locationProvider,
    $urlMatcherFactoryProvider, uiSelectConfig ) ->
    uiSelectConfig.theme = 'bootstrap'
    $urlRouterProvider.when('/jurisdictions/:jurisdictionId',
      '/jurisdictions/:jurisdictionId/proposed-laws')
    $urlRouterProvider.when('/jurisdictions/:jurisdictionId/proposed-laws',
      '/jurisdictions/:jurisdictionId/proposed-laws/page/1')
    $urlRouterProvider.when('/proposed-laws/:proposedLawId',
      '/proposed-laws/:proposedLawId/browse/')
    $urlRouterProvider.when('/proposed-laws/:proposedLawId/browse',
      '/proposed-laws/:proposedLawId/browse/')
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
        resolve:
          proposedLaw: (ProposedLaw, $stateParams) ->
            ProposedLaw.get({proposedLawId: $stateParams.proposedLawId}).$promise
        views:
          "navigation":
            templateUrl: 'navbar.html'
            controller: 'NavigationCtrl'
          "content":
            templateUrl: 'proposedLaw/layout.html'
            controller: 'ProposedLawCtrl'
      }
      .state 'proposedLaw.browse', {
        url: '/browse/{tree:path}'
        templateUrl: 'proposedLawNode/browse.html'
        controller: 'ProposedLawNodeCtrl'
      }
      .state 'proposedLaw.sections', {
        abstract: true
        url: '/sections'
        templateUrl: 'proposedLawSections/layout.html'
        controller: 'ProposedLawSectionsCtrl'
      }
      .state 'proposedLaw.sections.show', {
        url: '/show'
        templateUrl: 'proposedLawSections/show.html'
      }
      .state 'proposedLaw.section', {
        abstract: true
        url: '/:sectionNumber'
        templateUrl: 'proposeLawSection/layout.html'
        controller: 'ProposedLawSectionCtrl'
      }
      .state 'proposedLaw.section.edit', {
        url: '/edit'
        templateUrl: 'proposedLawSection/edit.html'
      }
    $urlRouterProvider.otherwise '/'
    $locationProvider.html5Mode true
