# Aruba-Doubles

Stub and mock command line applications with Cucumber

## Introduction

Developing a command line application in proper [BDD](http://en.wikipedia.org/wiki/Behavior_Driven_Development)-style with [Cucumber](http://cukes.info/) and [Aruba](https://github.com/cucumber/aruba) can be cumbersome, when your application depends on other CLI stuff (i.e. calling under certain conditions `kill_the_cat`).
Mocking and stubbing with Cucumber is usually [not recommended](https://github.com/cucumber/cucumber/wiki/Mocking-and-Stubbing-with-Cucumber) and tricky because we have do do it across processes but, in some cases it could make your life easier (Your cat will thank you later!)
Aruba-Doubles are some convenient Cucumber steps to fake CLI applications during your tests (by injecting temporary doubles in front of your PATH).

(Note: Aruba-Doubles is not an official part of Aruba but a good companion in the same domain, hence the name.)

## Usage

If you have a `Gemfile`, add `aruba-doubles`. Otherwise, install it like this:

    gem install aruba-doubles

Then, `require` the library in one of your ruby files under `features/support` (e.g. `env.rb`)

    require 'aruba-doubles/cucumber'

Here are some examples:

		Scenario: Stubbing with exit code and stderr
			Given a double of "kill_the_cat" with exit status 255 and stderr:
				"""
				ERROR: You don't even have a cat!
				"""
			When I run `my_fancy_new_script`
			Then ...
			
		Scenario: Mocking
			Given a double of "kill_the_cat --gently" with stdout:
				"""
				R.I.P.
				"""
			When I run `kill_the_cat`
			Then the stdout should contain exactly:
				"""
				"""
			And the stderr should contain exactly:
				"""
				expected: kill_the_cat --gently
				     got: kill_the_cat 
				"""

Take a peek at `features/*.feature` for further examples and at `lib/aruba-doubles/cucumber.rb` for all step definitions.

## Caveats

Aruba-Double won't work, if your command...

* calls other commands with absolute path, i.e. `/usr/local/kill_the_cat`
* defines its own PATH
* calls build-in commands from your shell like `echo` (but who want to stub that)

Also note that doubles will be created as scripts in temporary directories on your filesystem, which might slow down your tests.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.  Note: the existing tests may fail
* Commit, do not mess with Rakefile, gemspec or History.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Björn Albers. See LICENSE for details.
