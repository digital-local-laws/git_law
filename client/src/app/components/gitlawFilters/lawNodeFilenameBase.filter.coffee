angular.module 'gitlawFilters'
  .filter 'lawNodeFilenameBase', (lawNodeNamePartsFilter) ->
    (node) ->
      parts = lawNodeNamePartsFilter node
      text = if parts.number
        ( parts.label.toLowerCase() + '-' + parts.number )
      else
        parts.title.toLowerCase().replace(/[^a-z]/g,'-')
      if text
        text.replace(/^\-*/,'').replace(/\-*$/,'').replace(/\-+/,'-')
      else
        ''
