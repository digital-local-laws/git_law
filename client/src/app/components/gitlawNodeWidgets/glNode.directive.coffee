angular.module 'gitlawNodeWidgets'
  .directive 'glNode', () ->
    restrict: 'E'
    scope:
      node: '=glNodeLocation'
      repo: '=glRepo'
    transclude: true
    templateUrl: 'app/components/gitlawNodeWidgets/nodeLocation.html'
