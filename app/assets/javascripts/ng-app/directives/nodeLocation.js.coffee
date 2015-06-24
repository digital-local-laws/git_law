angular.module('glNodeLocationDirective',[]).
directive('glNode', [ 'ProposedLawNode', (ProposedLawNode) ->
  link = ( scope, el, attr ) ->
    onLoad = ( result ) ->
      scope.repo.sections = result
    ProposedLawNode.query( {
      proposedLawId: scope.repo.id
      treeBase: 'proposed-law' }, onLoad )
  restrict: 'E'
  link: link
  scope:
    node: '=glNodeLocation'
    repo: '=glRepo'
  transclude: true
  templateUrl: 'gl/nodeLocation.html'
] )
