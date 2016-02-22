angular.module 'gitlawFilters'
  .filter 'lawNodeNameParts', (capitalizeFirstFilter) ->
    (node) ->
      label:
        if node.nodeType && node.nodeType.label
        then capitalizeFirstFilter(node.nodeType.label.toString())
        else ''
      number:
        if node.attributes.number
        then node.attributes.number.toString()
        else ''
      title:
        if node.attributes.title
        then node.attributes.title.toString()
        else ''
