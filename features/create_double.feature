Feature: Create Double

	In order to stub command line applications
	As a BDD-guy
	I want to create doubles

	Background:
		Given a file named "foo" with:
			"""
			#!/usr/bin/env ruby
			puts "stdout of foo"
			warn "stderr of foo"
			exit 1
			"""
		And I run `chmod +x foo`
		And I append the current working dir to my path

	Scenario: The real application we want to stub
		When I run `foo`
		Then the exit status should be 1
		And the stdout should contain exactly:
			"""
			stdout of foo\n
			"""
		And the stderr should contain exactly:
			"""
			stderr of foo\n
			"""

	Scenario: Stub application
		Given I stub `foo`
		When I run `foo`
		Then the exit status should be 0
		And the stdout should contain exactly:
			"""
			"""
		And the stderr should contain exactly:
			"""
			"""

	Scenario: The real application we want to stub
		When I run `foo`
		Then the exit status should be 1
		And the stdout should contain exactly:
			"""
			stdout of foo\n
			"""
		And the stderr should contain exactly:
			"""
			stderr of foo\n
			"""