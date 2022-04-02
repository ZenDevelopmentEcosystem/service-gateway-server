Feature: package

The servicegwd python packages.

Scenario: Install wheel package
    Given wheel-package
    And venv
    And timeout 30 seconds
    When install in venv
    Then exit code 0
    And servicegwd entry-point exists
    And pip package `servicegwd` is installed

Scenario: Install sdist package
    Given sdist-package
    And venv
    And timeout 30 seconds
    When install in venv
    Then exit code 0
    And servicegwd entry-point exists
    And pip package `servicegwd` is installed
