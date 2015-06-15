angular
  .module 'gitLaw'
  .factory( 'CodeLevel', () ->
    () -> {
      label: ''
      number: 1
      optional: false
      text: false
      title: false } )
