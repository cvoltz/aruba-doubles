Feature: Double Commands

  In order to avoid that my system-under-test runs certain commands
  As a BDD-guy
  I want to double command line applications

  Scenario: Run the original (undoubled) command
    When I run `wc --help`
    Then the stdout should contain "Usage: /usr/bin/wc"

  Scenario: Run the original (undoubled) command with the script present
    Given an executable named "wc" with:
      """ruby
      #!/usr/bin/env ruby
      puts "stdout of foo"
      warn "stderr of foo"
      exit 5
      """
    When I run `wc --help`
    Then the stdout should contain "Usage: /usr/bin/wc"

  Scenario: Double and run the command
    Given I double `wc`
    When I run `wc --help`
    Then the exit status should be 0
    And the stdout should not contain "Usage: /usr/bin/wc"

  Scenario: Run the original (undoubled) command
    When I run `wc --help`
    Then the stdout should contain "Usage: /usr/bin/wc"
