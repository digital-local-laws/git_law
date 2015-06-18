angular.module('glNodeLocationDirective',[]).
directive('glNode', ->
  restrict: 'E'
  scope:
    node: '=glNodeLocation'
    repo: '=glRepo'
  transclude: true
  templateUrl: 'gl/nodeLocation.html'
)
