Feature: Double Commands

  In order to avoid that my system-under-test runs certain commands
  As a BDD-guy
  I want to double command line applications

  Background:
    Given an executable named "foo" with:
      """ruby
      #!/usr/bin/env ruby
      puts "stdout of foo"
      warn "stderr of foo"
      exit 5
      """
    And I look for executables in "." within the current directory

  Scenario: Run the original (undoubled) command
    When I run `foo`
    Then the exit status should be 5
    And the stdout should contain "stdout of foo"
    And the stderr should contain "stderr of foo"

  Scenario: Double and run the command
    Given I double `foo`
    When I run `foo`
    Then the exit status should be 0
    And the stdout should not contain "stdout of foo"
    And the stderr should not contain "stderr of foo"

  Scenario: Run the original (undoubled) command
    When I run `foo`
    Then the exit status should be 5
    And the stdout should contain "stdout of foo"
    And the stderr should contain "stderr of foo"
