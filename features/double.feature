Feature: Double command line applications

	In order to double command line applications
	As a developer using Cucumber
	I want to use the "I could run" steps

	Scenario: Stub with default stdout, stderr and exit status
		Given I could run `foo`
		When I successfully run `foo`
		Then the stdout should be empty
		And the stderr should be empty

	Scenario: Stub stdout
		Given I could run `foo` with stdout:
			"""
			hello, world.
			"""
		When I successfully run `foo`
		Then the stdout should contain exactly:
			"""
			hello, world.
			
			"""
		And the stderr should be empty

	 Scenario: Stub stderr
		Given I could run `foo` with stderr:
	 		"""
	 		error: something crashed!
	 		"""
	 	When I successfully run `foo`
	 	And the stdout should be empty
	 	Then the stderr should contain exactly:
	 		"""
	 		error: something crashed!
   
	 		"""

	Scenario: Stub exit status
		Given I could run `foo` with exit status 255
		When I run `foo`
		Then the exit status should be 255
		And the stdout should be empty
		And the stderr should be empty

	Scenario: Stub exit status and stdout
		Given I could run `foo` with exit status 255 and stdout:
			"""
			hello, world.
			"""
		When I run `foo`
		Then the exit status should be 255
		And the stdout should contain exactly:
			"""
			hello, world.
			
			"""			
		And the stderr should be empty

	Scenario: Run with unexpected arguments
		Given I could run `foo --bar 'hello, world.'`
		When I successfully run `foo --bar 'hello, world.'`
		Then the stdout should be empty
		And the stderr should be empty
		When I run `foo --bar hello world`
		Then the exit status should not be 0
		And the stdout should be empty
		And the stderr should contain:
			"""
			Unexpected arguments: ["--bar", "hello", "world"]
			"""

	Scenario: Stub multiple calls
		Given I could run `foo --bar` with stdout:
			"""
			hello, bar.
			"""
		And I could run `foo --baz` with stdout:
			"""
			hello, baz.
			"""
		When I successfully run `foo --bar`
		And the stdout should contain "hello, bar."
		And the stdout should not contain "hello, baz."
		And the stderr should be empty
		When I successfully run `foo --baz`
		And the stdout should contain "hello, baz."
		And the stderr should be empty
