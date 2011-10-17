Feature: Environment-friendly

	In order to not mess up my system or tests
	As a developer using Cucumber
	I want Aruba-Doubles to behave environment-friendly

	Scenario: Create doubles directory only when necessary
		When I run `ls`
		Then the doubles directory should not exist

	Scenario: Patch the original path only once
		Given a double of "ls"
		And a double of "ls"
		Then the path should include 1 doubles directory

	Scenario: Create doubles directory...
		Given a double of "ls"
		When I keep the doubles directory in mind
	
	Scenario: ...and check that it was deleted
		Then the previous doubles directory should not exist

		