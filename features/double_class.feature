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

	Scenario: Stdout
		Given a file named "foo" with:
			"""
			require 'aruba-doubles/double'
			
			double = Double.new
			double.stub(:stdout => "hello, world.")
			double.run!
			"""
	 When I successfully run `ruby foo`
	 Then the stdout should contain exactly:
	 	"""
		hello, world.
		
	 	"""
	 Then the stderr should be empty


			
