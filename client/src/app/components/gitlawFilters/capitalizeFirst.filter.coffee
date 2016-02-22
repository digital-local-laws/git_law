angular.module 'gitlawFilters'
  .filter 'capitalizeFirst', ->
    (string) ->
      return string unless string.length > 0
      string.charAt(0).toUpperCase() + string.slice(1)
