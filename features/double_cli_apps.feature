Feature: Double command line applications

	In order to double command line applications
	As a developer using Cucumber
	I want to use the "double of" steps

	@announce
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

