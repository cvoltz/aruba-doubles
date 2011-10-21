Feature: Double command line applications

	In order to double command line applications
	As a developer using Cucumber
	I want to use the "double of" steps

	Scenario: Double default behaviour
		Given a double of "foo"
		When I run `foo`
		Then the exit status should be 0
		And the stdout should contain exactly:
			"""
			"""			
		And the stderr should contain exactly:
			"""
			"""

	Scenario: Double with stdout
		Given a double of "foo" with stdout:
			"""
			hello, world.
			"""
		When I successfully run `foo`
		Then the stdout should contain exactly:
			"""
			hello, world.
			
			"""
		And the stderr should contain exactly:
			"""
			"""

	 Scenario: Double with stderr
	 	Given a double of "foo" with stderr:
	 		"""
	 		error: something crashed!
	 		"""
	 	When I successfully run `foo`
	 	And the stdout should contain exactly:
	 		"""
	 		"""
	 	Then the stderr should contain exactly:
	 		"""
	 		error: something crashed!
   
	 		"""

	Scenario: Double with exit status
		Given a double of "foo" with exit status 255
		When I run `foo`
		Then the exit status should be 255
		And the stdout should contain exactly:
			"""
			"""			
		And the stderr should contain exactly:
			"""
			"""

	Scenario: Double with exit status and stdout
		Given a double of "foo" with exit status 255 and stdout:
			"""
			hello, world.
			"""
		When I run `foo`
		Then the exit status should be 255
		And the stdout should contain exactly:
			"""
			hello, world.
			
			"""			
		And the stderr should contain exactly:
			"""
			"""

	Scenario: Double with expected arguments
		Given a double of "ls --la" with stdout:
			"""
			hello, world.
			"""
		When I run `ls`
		Then the exit status should not be 0
		And the stdout should contain exactly:
			"""
			"""
		And the stderr should contain exactly:
			"""
			expected: --la
			     got: 
			
			"""
			

	@repeat_arguments
	Scenario: Double with repeating arguments
		Given a double of "foo"
		When I run `foo`
		Then the stdout should contain exactly:
			"""
			foo
			
			"""
		And the stderr should contain exactly:
			"""
			"""

