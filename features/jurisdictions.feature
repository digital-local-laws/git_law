Feature: Uploading jurisdictions
  In order to house local laws
  As a local law repositary
  I want to set up and manage jurisdiction spaces
  @javascript
  Scenario Outline: Authorization for user
    Given I log in as <role>
    And a jurisdiction exists
    Then I <create> create jurisdictions
    And I <update> update jurisdictions
    And I <destroy> destroy jurisdictions
    Examples:
      | role  | create  | update  | destroy |
      | admin | may     | may     | may     |
      | staff | may     | may     | may not |
      | user  | may not | may not | may not |
  @javascript
  Scenario: Add jurisdiction
    Given I log in as admin
    And I add a jurisdiction
    Then I should see the jurisdiction was added
    And the jurisdiction should be recorded in the database
  @javascript
  Scenario: Remove jurisdiction
    Given I log in as admin
    And I added a jurisdiction
    When I remove the jurisdiction
    Then I should see the jurisdiction was removed
    And the jurisdiction should not be recorded in the database
  @javascript
  Scenario: Modify jurisdiction settings
    Given I log in as admin
    And I added a jurisdiction
    When I edit the jurisdiction settings
    Then I should see the jurisdiction settings were updated
    And the jurisdiction settings should be updated
