Feature: User management
  In order to control user accounts
  As an administrator
  I want to manage user accounts in the system
  @javascript
  Scenario Outline: Authorization for user
    Given I log in as <role>
    And another user named Al Smith exists
    Then I <create> create users
    And I <authorize> authorize users
    And I <update> update users
    And I <destroy> destroy users
    Examples:
      | role  | create | authorize | update  | destroy |
      | admin | may    | may       | may     | may     |
      | staff | may    | may not   | may     | may not |
  @javascript
  Scenario: List users
    Given I log in as admin
    When I go to the users listing
    Then I should see myself in the users listing
  @javascript
  Scenario: Create user
    Given I log in as admin
    When I go to the users listing
    And I create another user named Al Smith
    Then I should see the user was created
    And I should see Al Smith in the users listing
  @javascript
  Scenario: Edit user
    Given I log in as admin
    And another user named Al Smythe exists
    When I go to the users listing
    And I edit Al Smythe in the users listing
    Then I should see the user was updated
    And the user should be updated
    And I should not see Al Smythe in the users listing
    And I should see Alfred Smith in the users listing
  @javascript
  Scenario: Remove user
    Given I log in as admin
    And another user named Al Smith exists
    And I go to the users listing
    When I remove Al Smith from the users listing
    Then I should not see Al Smith in the users listing
