Feature: User sessions
  In order to assure accountability for actions
  As a priveleged user
  I want to log in and log out
  @javascript
  Scenario: Log in
    Given I log in
    Then I should be logged in
  @javascript
  Scenario:
    Given I log in
    When I log out
    Then I should be logged out

