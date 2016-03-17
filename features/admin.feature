Feature: System administration
  In order to control platform-wide functions
  As an administrator
  I want to have an administration section
  @javascript
  Scenario Outline: Access control to system administration
    Given I log in as <role>
    Then I <users> go to administration
    Examples:
      | role  | users   |
      | admin | may     |
      | staff | may     |
      | user  | may not |
      | nobody| may not |
