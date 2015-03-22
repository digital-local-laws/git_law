Feature: Uploading codes
  In order to get data into the dashboards
  As a data preparer
  I want to upload data
  @javascript
  Scenario: Add code
    Given I add a code
    Then I should see the code was added
    And the code should be recorded in the database
  @javascript
  Scenario: Remove code
    Given I added a code
    When I remove the code
    Then I should see the code was removed
    And the code should not be recorded in the database
  @selenium
  Scenario: Modify code
    Given I added a code
    When I edit the code settings
    Then I should see the code settings were updated
    And the code settings should be updated
