Feature: Any arguments

	In order to keep my scenarios dry
	As a BDD-guy
	I want create doubles that accept and respond to any arguments

	# Scenario: Output default values for unexpected arguments
	# 	Given I could run `foo` with any arguments
	# 	When I successfully run `foo --unexpected arguments`
	# 	Then the stdout should be empty
	# 	And the stderr should be empty
	# 
	# Scenario: Log unexpected arguments
	# 	Given I could run `foo` with any arguments
	# 	When I run `foo --unexpected arguments`
	# 	Then `foo --unexpected arguments` should have been run
	# 
	# Scenario: Preserve output for expected arguments
	# 	Given I could run `foo` with any arguments
	# 	And I could run `foo --expected arguments` with exit status 42 and stderr:
	# 		"""
	# 		hello, world.
	# 		"""
	# 	When I run `foo --expected arguments`
	# 	Then the stderr should contain "hello, world."
	# 	And the exit status should be 42
