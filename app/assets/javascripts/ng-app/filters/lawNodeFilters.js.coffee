angular.module('lawNodeFilters',[]).
filter('capitalizeFirst', ->
  (string) ->
    return string unless string.length > 0
    string.charAt(0).toUpperCase() + string.slice(1) ).
filter('lawNodeNameParts', (capitalizeFirstFilter) ->
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
).
filter('lawNodeTitle', (lawNodeNamePartsFilter) ->
  (node) ->
    parts = lawNodeNamePartsFilter node
    text = if parts.label && parts.number
      parts.label + ' ' + parts.number + '.'
    else
      ''
    if parts.title
      text = if text then text + ' ' + parts.title else parts.title
    text
).
filter('lawNodeShortTitle', (lawNodeNamePartsFilter) ->
  (node) ->
    parts = lawNodeNamePartsFilter node
    text = if parts.label && parts.number
      parts.label + ' ' + parts.number
    else
      parts.title
    text
).
filter('lawNodeFilename', (lawNodeNamePartsFilter) ->
  (node) ->
    parts = lawNodeNamePartsFilter node
    text = if parts.number
      ( parts.label.toLowerCase() + '-' + parts.number )
    else
      parts.title.toLowerCase().replace(/[^a-z]/g,'-')
    if text
      text.replace(/^\-*/,'').replace(/\-*$/,'').replace(/\-+/,'-') + '.json'
    else
      '' )
