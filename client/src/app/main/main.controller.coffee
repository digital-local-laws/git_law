angular.module 'client'
  .controller 'MainController', ( $location ) ->
    if $location.search().goto
      $location.url $location.search().goto
    return
