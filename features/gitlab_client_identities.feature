Feature: GitLab Identities
  In order to access work stored in GitLab repositories
  As a user
  I want to manage my GitLab Identities
  @javascript
  Scenario Outline: Authorization
    Given I log in as <role>
    Then I <identities> go to <user> client identities listing
    Examples:
      | role        | identities | user      |
      | staff       | may        | another's |
      | user        | may        | my        |
      | user        | may not    | another's |
      | nobody      | may not    | my        |
  @javascript
  Scenario: Register an identity
    Given I log in
    When I go to my client identities listing
    Then I should see no gitlab client identity in the listing
    When I add a gitlab client identity
    Then I should be redirected to the gitlab host for authorization
  @javascript
  Scenario: See a registered identity
    Given I log in
    And I have a gitlab client identity
    When I go to my client identities listing
    Then I should see the gitlab client identity in the listing
  @javascript
  Scenario: Remove a registered identity
    Given I log in
    And I have a gitlab client identity
    And I go to my client identities listing
    When I remove a gitlab client identity
    Then I should see no gitlab client identity in the listing
    And I should have no gitlab client identity
