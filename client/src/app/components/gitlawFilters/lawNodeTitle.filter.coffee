angular.module 'gitlawFilters'
  .filter 'lawNodeTitle', (lawNodeNamePartsFilter) ->
    (node) ->
      parts = lawNodeNamePartsFilter node
      text = if parts.label && parts.number
        parts.label + ' ' + parts.number + '.'
      else
        ''
      if parts.title
        text = if text then text + ' ' + parts.title else parts.title
      text
