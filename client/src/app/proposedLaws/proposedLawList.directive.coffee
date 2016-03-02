angular.module 'client'
  .directive 'proposedLawList', () ->
    {
      scope: true
      templateUrl: 'app/proposedLaws/proposedLawList.html'
    }
