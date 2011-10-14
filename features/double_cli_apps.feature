Feature: Double command line applications

	In order to double command line applications
	As a developer using Cucumber
	I want to use the "double of" steps

	Scenario: Double default behaviour
		Given a double of "ls"
		When I run `ls -la`
		Then the exit status should be 0
		And the stdout should contain exactly:
			"""
			"""			
		And the stderr should contain exactly:
			"""
			"""

	Scenario: Double with stdout
		Given a double of "ls" with stdout:
			"""
			hello, world.
			"""
		When I successfully run `ls -la`
		Then the stdout should contain exactly:
			"""
			hello, world.
			
			"""
		And the stderr should contain exactly:
			"""
			"""

	 Scenario: Double with stderr
	 	Given a double of "ls" with stderr:
	 		"""
	 		error: something crashed!
	 		"""
	 	When I successfully run `ls -la`
	 	And the stdout should contain exactly:
	 		"""
	 		"""
	 	Then the stderr should contain exactly:
	 		"""
	 		error: something crashed!
   
	 		"""

	Scenario: Double with exit status
		Given a double of "ls" with exit status 255
		When I run `ls -la`
		Then the exit status should be 255
		And the stdout should contain exactly:
			"""
			"""			
		And the stderr should contain exactly:
			"""
			"""

	Scenario: Double with exit status and stdout
		Given a double of "ls" with exit status 255 and stdout:
			"""
			hello, world.
			"""
		When I run `ls -la`
		Then the exit status should be 255
		And the stdout should contain exactly:
			"""
			hello, world.
			
			"""			
		And the stderr should contain exactly:
			"""
			"""

	@repeat_arguments
	Scenario: Double with repeating arguments
		Given a double of "ls"
		When I run `ls -la`
		Then the stdout should contain exactly:
			"""
			ls -la
			
			"""
		And the stderr should contain exactly:
			"""
			"""

