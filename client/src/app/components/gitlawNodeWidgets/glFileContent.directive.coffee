angular.module 'gitlawNodeWidgets'
  .directive 'glFileContent', ->
    scope: { }
    controllerAs: 'ctrl'
    bindToController:
      file: '=glFile'
      text: '=glText'
      timeout: '=glTimeout'
      onLoad: '&glOnLoad'
      onChange: '&glOnChange'
    controller: ( $scope, $timeout ) ->
      ctrl = this
      $scope.onLoad = (e) ->
        ctrl.onLoad( editor: e )
      $scope.editorMode = switch ctrl.file.fileNameExtension
        when '.json' then 'json'
        else 'asciidoc'
      $scope.text = ctrl.text
      $scope.saveInProgress = false
      if ctrl.timeout || ctrl.timeout = 0
        timeoutDelay = ctrl.timeout
      else
        timeoutDelay = 5000
      timeout = null
      cancelTimeout = () ->
        $timeout.cancel timeout if timeout
      # Asynchronously call onChange method to process data according to
      # timeout specified in parameters for this directive
      debounceOnChange = ( text ) ->
        onChange = () ->
          ctrl.onChange(
            newVal: text
            callback: ->
              $scope.saveInProgress = false
          )
        cancelTimeout()
        $scope.saveInProgress = true
        if timeoutDelay == 0
          onChange()
        else
          timeout = $timeout( onChange, timeoutDelay )
      $scope.$watch 'text', ( newVal, oldVal ) ->
        if newVal != oldVal
          debounceOnChange( newVal )
      $scope.$on 'destroy', ->
        cancelTimeout()
    restrict: 'E'
    templateUrl: 'app/components/gitlawNodeWidgets/fileContent.html'
