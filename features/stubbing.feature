Feature: stubbing

	In order to stub command line applications
	As a developer using Cucumber
	I want to use the "a stubbed command" steps

	Scenario: Stub without stdout
		Given a stubbed command "thisdoesnotexist"
		When I run `thisdoesnotexist`
		Then the exit status should be 0

	Scenario: Stub with stdout
		Given a stubbed command "thisprintstostdout" with stdout:
			"""
			hello, world!
			"""
		When I run `thisprintstostdout`
		Then the stdout should contain "hello, world!"

	Scenario: Stub existing command line application
		Given a stubbed command "ls" with stdout:
			"""
			sorry, just a double
			"""
		When I run `ls`
		Then the stdout should contain "sorry, just a double"

