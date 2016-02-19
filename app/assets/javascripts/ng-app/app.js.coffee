angular
  .module 'gitLaw', [ 'angularFileUpload', 'ngAnimate', 'ngSanitize',
     'ui.select', 'ui.router', 'ngResource', 'templates', 'ui.utils',
    'ui.bootstrap', 'ui.tree', 'lawNodeFilters',
    'ui.ace', 'glFileContentDirective', 'glNodeLocationDirective',
    'ngFlash', 'ipCookie', 'ng-token-auth' ]
  .config ( $stateProvider, $urlRouterProvider, $locationProvider,
    $urlMatcherFactoryProvider, uiSelectConfig, $authProvider ) ->
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
    $authProvider.configure({
      omniauthWindowType: 'sameWindow'
      authProviderPaths: {
        developer: '/auth/developer'
      }
    })
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
        views:
          "navigation":
            templateUrl: 'navbar.html'
            controller: 'NavigationCtrl'
          "content":
            templateUrl: 'adoptedLaw/layout.html'
            controller: 'AdoptedLawCtrl'
      }
    $urlRouterProvider.otherwise '/'
    $locationProvider.html5Mode true
  .run [ '$rootScope', '$auth', '$state', 'Flash',
    ( $rootScope, $auth, $state, Flash ) ->
      # Check on page load whether user is logged in
      $auth.validateUser().then ( user ) ->
        $rootScope.currentUser = user
      # Notify user that he or she is logged in
      $rootScope.notifyCurrentUser = () ->
        Flash.create( 'info', 'You logged in as ' +
          $rootScope.currentUser.name + '.' )
        $state.go 'home'
      # Record user information on login
      $rootScope.$on 'auth:login-success', (ev, user) ->
        $rootScope.currentUser = user
        $rootScope.notifyCurrentUser()
      # Purge user information on logout
      $rootScope.$on 'auth:logout-success', ->
        $rootScope.currentUser = false
        Flash.create( 'info', 'You logged out.' )
        $state.go 'home'
  ]
