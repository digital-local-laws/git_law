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
  @javascript
  Scenario: Remove a proposed law
    Given I proposed a law
    When I remove the proposed law
    Then I should see the proposed law was removed
    And the proposed law should not be recorded in the database
  @javascript
  Scenario: Modify proposed law settings
    Given I proposed a law
    When I edit the proposed law settings
    Then the proposed law settings should be updated
  @javascript
  Scenario: Add a code and edit its settings
    Given I proposed a law
    When I add a code
    Then the code should be added
    When I rename the code
    Then the code should be renamed
  @javascript
  Scenario Outline: Add a structured code
    Given I proposed a law
    And I added a structured code:
      | level | label   | number      | title | text  | optional |
      | 1     | part    | upper roman | yes   | no    | no       |
      | 2     | chapter | arabic      | yes   | no    | no       |
      | 3     | article | lower roman | yes   | no    | yes      |
      | 4     | section | arabic      | yes   | yes   | no       |
    When I add a <child> to the <parent> in the code
    Then the <child> should be added to the <parent> in the code
    When I go to the <parent> in the code
    And I change settings for the <child>
    Then the <child> settings should be changed in the code
    When I renumber the <child> in the code
    Then the <child> should be renumbered
    When I delete the <child> from the code
    Then the <child> should be absent from the code
    Examples:
      | child   | parent  |
      | part    | root    |
      | chapter | part    |
      | article | chapter |
      | section | chapter |
      | section | article |
  @javascript
  Scenario: Edit textual content of a structured code
    Given I proposed a law
    And I added a structured code:
      | level | label   | number      | title | text  | optional |
      | 1     | chapter | arabic      | yes   | no    | no       |
      | 2     | section | arabic      | yes   | yes   | no       |
    And I add a section to the chapter in the code
    And the section should be added to the chapter in the code
    When I edit the text of the section
    Then the section should should be changed
  @javascript
  Scenario: Add textual content to a structured code
    Given I proposed a law
    And I added a structured code:
      | level | label   | number      | title | text  | optional |
      | 1     | chapter | arabic      | yes   | no    | no       |
      | 2     | section | arabic      | yes   | yes   | no       |
    And I add a section to the chapter in the code
    Then the section should be added to the chapter in the code
    Given the section has no text
    When I add text to the section
    Then text should be added to the section
