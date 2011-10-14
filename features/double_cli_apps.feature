Feature: Double command line applications

	In order to double command line applications
	As a developer using Cucumber
	I want to use the "double of" steps

	Scenario: Stub without stdout
		Given a double of "thisdoesnotexist"
		When I run `thisdoesnotexist`
		Then the exit status should be 0

	Scenario: Stub with stdout
		Given a double of "thisprintstostdout" with stdout:
			"""
			hello, world!
			"""
		When I run `thisprintstostdout`
		Then the stdout should contain "hello, world!"

	Scenario: Stub existing command line application
		Given a double of "ls" with stdout:
			"""
			sorry, just a double
			"""
		When I run `ls`
		Then the stdout should contain "sorry, just a double"

