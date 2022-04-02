Feature: Help

Scenario: Print top help (long)
    Given servicegwd
    And timeout 5 seconds
    When servicegwd run with argument(s) `--help`
    Then exit code 0
    And output contains 'Usage'

Scenario: Print top help (short)
    Given servicegwd
    And timeout 5 seconds
    When servicegwd run with argument(s) `-h`
    Then exit code 0
    And output contains 'Usage'
