Feature: Double command line applications

	In order to double command line applications
	As a developer using Cucumber
	I want to use the "double of" steps

	Scenario: Default behaviour
		Given a double of "foo"
		When I successfully run `foo`
		Then the stdout should be empty
		And the stderr should be empty

	Scenario: Stub everything
		Given a double of "foo"
		When I successfully run `foo --bar baz`
		Then the stdout should be empty
		And the stderr should be empty
		
	Scenario: Return to stdout
		Given a double of "foo" with stdout:
			"""
			hello, world.
			"""
		When I successfully run `foo`
		Then the stdout should contain exactly:
			"""
			hello, world.
			
			"""
		And the stderr should be empty

	 Scenario: Return to stderr
	 	Given a double of "foo" with stderr:
	 		"""
	 		error: something crashed!
	 		"""
	 	When I successfully run `foo`
	 	And the stdout should be empty
	 	Then the stderr should contain exactly:
	 		"""
	 		error: something crashed!
   
	 		"""

	Scenario: Set exit status
		Given a double of "foo" with exit status 255
		When I run `foo`
		Then the exit status should be 255
		And the stdout should be empty
		And the stderr should be empty

	Scenario: Set exit status and return to stdout
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
		And the stderr should be empty

	# Scenario: Double with expected arguments
	# 	Given a double of "foo --bar baz" with stdout:
	# 		"""
	# 		hello, world.
	# 		"""
	# 	When I run `foo`
	# 	Then the exit status should not be 0
	# 	And the stdout should be empty
	# 	And the stderr should contain exactly:
	# 		"""
	# 		expected: foo --bar baz
	# 		     got: foo 
	# 		
	# 		"""
