angular.module 'gitlawModels'
  .factory 'CodeLevel', () ->
    () -> {
      label: ''
      number: 1
      optional: false
      text: false
      title: false }
