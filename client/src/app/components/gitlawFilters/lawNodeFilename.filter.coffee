angular.module 'gitlawFilters'
  .filter 'lawNodeFilename', (lawNodeFilenameBase) ->
    (node) ->
      base = lawNodeFilenameBase node
      if base
        base + '.json'
      else
        ''
