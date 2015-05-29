Feature: Manage local laws
  In order to comply with filing mandates
  As a local official
  I want to propose, review, and submit local laws
  @javascript
  Scenario: Propose a law
    Given a jurisdiction exists
    And I log in
    And I visit the jurisdiction's page
    When I propose a law
    Then the proposed law should be added
  @javascript @wip
  Scenario: Remove a proposed law
    Given I proposed a law
    When I remove the proposed law
    Then I should see the proposed law was removed
    And the proposed law should not be recorded in the database
  @selenium @wip
  Scenario: Modify proposed law settings
    Given I proposed a law
    When I edit the proposed law settings
    Then the proposed law settings should be updated
  @javascript @wip
  Scenario: Add a code
    Given I proposed a law
    When I go to browse the proposed law
    And I add a code
    Then the code should be added
