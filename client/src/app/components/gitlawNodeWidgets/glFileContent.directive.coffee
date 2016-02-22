angular.module 'gitlawNodeWidgets'
  .directive 'glFileContent', ->
    link = ( scope, element, attrs ) ->
      scope.editorMode = (file) ->
        return 'asciidoc' unless file
        switch file.file_name_extension
          when '.json' then 'json'
          else 'asciidoc'
    restrict: 'E'
    link: link
    scope:
      file: '=glFile'
      onLoad: '=glOnLoad'
    templateUrl: 'app/components/gitlawNodes/fileContent.html'
