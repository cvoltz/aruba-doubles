Feature: Double class

	In order to easily generate doubles
	As a developer building Aruba-Doubles
	I want an simple and easy to use double class

	Scenario: Default values
		Given a file named "foo" with:
			"""
			require 'aruba-doubles/double'
			
			double = Double.new
			double.run!
			"""
		When I successfully run `ruby foo`
		Then the stdout should be empty
		Then the stderr should be empty

	Scenario Outline: stdout, stderr and exit status
		Given a file named "foo" with:
			"""
			require 'aruba-doubles/double'
			
			double = Double.new
			double.stub(<stub_options>)
			double.run!
			"""			
		When I run `ruby foo`
		Then the exit status should be <exit>
		And the stdout should <stdout>
		And the stderr should <stderr>

		Scenarios:
		 | stub_options       | stdout        | stderr        | exit |
		 | :stdout => "hi."   | contain "hi." | be empty      | 0    |
		 | :stderr => "ho!"   | be empty      | contain "ho!" | 0    |
		 | :exit_status => 42 | be empty      | be empty      | 42   |


			
