Feature: Define Output

	In order to double a command line application
	As a BDD-guy
	I want to define the doubles output

  Scenario: Default output when not defined
    Given I double `foo`
    When I run `foo`
    Then the exit status should be 0
    When I run `foo --bar baz`
    Then the exit status should be 0
    And the stdout should be empty
    And the stderr should be empty

  @announce
	Scenario: Define stdout
    Given I double `foo` with stdout "hello, world."
    When I run `foo`
    Then the exit status should be 0
    And the stdout should contain "hello, world."
    And the stderr should be empty

	Scenario: Define stdout and exit status
	Scenario: Define stderr
	Scenario: Define stderr and exit status
	Scenario: Define exit status

    #Scenario: Explicit output when run without arguments
    #Given I double `foo` with stdout "hello, world."
    #When I run `foo --bar baz`
    #Then the stdout should not contain "hello, world."
    #When I run `foo`
    #Then the stdout should contain "hello, world."

	Scenario: Explicit output when run with certain arguments
	Scenario: Explicit output for multiple scenarios

	# Scenario: Define default output ???
