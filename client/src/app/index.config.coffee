angular.module 'client'
  .config ($logProvider, toastrConfig) ->
    'ngInject'
    # Enable log
    $logProvider.debugEnabled true
    # Set options third-party lib
    toastrConfig.allowHtml = true
    toastrConfig.timeOut = 3000
    toastrConfig.positionClass = 'toast-top-right'
    toastrConfig.preventDuplicates = true
    toastrConfig.progressBar = true
  .config ( $locationProvider, uiSelectConfig, $authProvider ) ->
    # TODO how can we enable HTML5 mode?
    # $locationProvider.html5Mode true
    uiSelectConfig.theme = 'bootstrap'
    $authProvider.configure({
      omniauthWindowType: 'sameWindow'
      authProviderPaths: {
        developer: '/auth/developer'
      }
    })
