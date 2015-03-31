Feature: Uploading jurisdictions
  In order to house local laws
  As a local law repositary
  I want to set up and manage jurisdiction spaces
  @javascript
  Scenario: Add jurisdiction
    Given I add a jurisdiction
    Then I should see the jurisdiction was added
    And the jurisdiction should be recorded in the database
  @javascript
  Scenario: Remove jurisdiction
    Given I added a jurisdiction
    When I remove the jurisdiction
    Then I should see the jurisdiction was removed
    And the jurisdiction should not be recorded in the database
  @selenium
  Scenario: Modify jurisdiction settings
    Given I added a jurisdiction
    When I edit the jurisdiction settings
    Then I should see the jurisdiction settings were updated
    And the jurisdiction settings should be updated
