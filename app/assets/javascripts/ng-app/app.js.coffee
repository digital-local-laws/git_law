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
        templateUrl: 'home.html',
        controller: 'HomeCtrl'
      }
      .state 'dashboard', {
        abstract: true,
        url: '/dashboard',
        templateUrl: 'dashboard/layout.html'
      }
      .state 'dashboard.one', {
        url: '',
        templateUrl: 'dashboard/one.html',
        controller: 'DashboardCtrl'
      }
      .state 'codes', {
        abstract: true,
        url: '/codes',
        templateUrl: 'codes/layout.html',
        controller: 'CodesCtrl'
      }
      .state 'codes.one', {
        url: '',
        templateUrl: 'codes/list.html',
        controller: 'CodesListCtrl'
      }
      .state 'codes.paginated', {
        url: '/page/:page'
        templateUrl: 'codes/list.html'
        controller: 'CodesListCtrl'
      }
    $urlRouterProvider.otherwise '/'
    $locationProvider.html5Mode true
