Feature: Version

Scenario: Print version
    Given servicegwd
    And timeout 5 seconds
    When servicegwd run with argument(s) `--version`
    Then exit code 0
    And output contains 'servicegwd, version [\d.\d.\d]'
