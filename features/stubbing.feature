Feature: stubbing

	In order to stub command line applications
	As a developer using Cucumber
	I want to use the "a stubbed command" step

	Scenario: Proof of concept
		Given a stubbed command "thisdoesnotexist"
		When I run `thisdoesnotexist`
		Then the exit status should be 0