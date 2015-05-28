angular.module('lawNodeFilters',[]).
filter('lawNodeFilename', ->
  (node,parentNode) ->
    name = if parentNode.childStructure
      parentNode.childStructure.name.toString()
    else
      ''
    number = if node.metadata.number
      node.metadata.number.toString()
    else
      ''
    title = if node.metadata.title
      node.metadata.title.toString()
    else
      ''
    text = if number
      ( name.toLowerCase() + '-' + number )
    else
      title.toLowerCase().replace(/[^a-z]/g,'-')
    text.replace(/^\-*/,'').replace(/\-*$/,'').replace(/\-+/,'-') )
