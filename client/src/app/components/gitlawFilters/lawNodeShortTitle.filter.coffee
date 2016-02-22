angular.module 'gitlawFilters'
  .filter 'lawNodeShortTitle', (lawNodeNamePartsFilter) ->
    (node) ->
      parts = lawNodeNamePartsFilter node
      text = if parts.label && parts.number
        parts.label + ' ' + parts.number
      else
        parts.title
      text
