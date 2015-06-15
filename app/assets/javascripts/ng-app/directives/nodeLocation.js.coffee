angular.module('glNodeLocationDirective',[]).
directive('glNodeLocation', ->
  restrict: 'A'
  scope:
    node: '=glNodeLocation'
    repo: '=glRepo'
  transclude: true
  templateUrl: 'gl/nodeLocation.html'
)
