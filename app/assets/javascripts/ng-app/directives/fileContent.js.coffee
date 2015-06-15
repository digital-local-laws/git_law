angular.module('glFileContentDirective',[]).
directive('glFileContent', ->
  link = ( scope, element, attrs ) ->
    setEditorMode = ->
      scope.editorMode = switch scope.file.fileNameExtension
        when '.json' then 'json'
        when '.asc' then 'asciidoc'
        else 'default'
    setEditorMode()
    scope.$watch 'file.fileNameExtension', ->
      setEditorMode()
  restrict: 'E'
  link: link
  scope:
    file: '=glFile'
  templateUrl: 'gl/fileContent.html' )
