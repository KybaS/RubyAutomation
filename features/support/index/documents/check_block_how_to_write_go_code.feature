Feature: Checking important Go land documents

  Scenario Outline: navigate to the go lang site and check documents
    Given open go land site
    When navigate to the Documents
    And open the How to Write Go Code page
    Then check the <block>

    Examples:
      | block              |
      | Your first program |
      | Your first library |