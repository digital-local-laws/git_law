Feature: Adopt local laws
  In order to comply with filing mandates
  As a local government official
  I want to submit and review adopted local laws for my jurisdiction
  @javascript
  Scenario Outline: Adopt a proposed law
    Given a jurisdiction exists
    And each law proposed for the jurisdiction <executive> subject to executive review
    And I proposed a law
    And I added a structured code:
      | level | label   | number      | title | text  | optional |
      | 1     | chapter | arabic      | yes   | no    | no       |
      | 2     | section | arabic      | yes   | yes   | no       |
    And I add a section to the chapter in the code
    And I edit the text of the section
    And saving has completed
    And I log out
    And I log in as adopter for the jurisdiction
    When I go to adopt the proposed law
    And I certify the proposed law <executive> <executive_action> executive review
    And I certify the law is subject to <referendum> referendum
    And I adopt the proposed law
    Then I should see the proposed law is adopted
    Examples:
      | executive | executive_action | referendum |
      | is not    | subject to       | no         |
      | is        | approved by      | no         |
      | is        | allowed by       | no         |
      | is        | rejected by      | no         |
      | is not    | subject to       | mandatory  |
      | is not    | subject to       | permissive |
      | is not    | subject to       | petition   |
  @javascript
  Scenario: See proposed laws for a jurisdiction
    Given I log in
    And a jurisdiction exists
    And an adopted law exists
    When I go to the adopted laws listing for the jurisdiction
    Then I should see the adopted law
