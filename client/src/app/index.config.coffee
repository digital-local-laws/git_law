angular.module 'client'
  .config ($logProvider) ->
    'ngInject'
    # Enable log
    $logProvider.debugEnabled true
  .config ( $locationProvider, uiSelectConfig, $authProvider,
  showErrorsConfigProvider ) ->
    # TODO how can we enable HTML5 mode?
    # $locationProvider.html5Mode true
    uiSelectConfig.theme = 'bootstrap'
    $authProvider.configure({
      apiUrl: '/api'
      omniauthWindowType: 'sameWindow'
      authProviderPaths: {
        developer: '/auth/developer'
      }
    })
    showErrorsConfigProvider.showSuccess true
