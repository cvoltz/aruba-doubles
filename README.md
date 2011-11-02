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

### Stubbing

You can stub commands by using the `I could run` steps:

	Background:
		Given I could run `kill_the_cat` with stdout:
			"""
			R.I.P.
			"""

	Scenario: Call stubbed command
		When I run `kill_the_cat`
		Then the exit status should be 0
		And the stdout should contain "R.I.P."
		And the stderr should be empty

	Scenario: Call stubbed command with unexpected argument
		When I run `kill_the_cat --force`
		Then the exit status should not be 0
		And the stdout should be empty
		And the stderr should contain "--force"

	Scenario: Add expected arguments to stub
		And I could run `kill_the_cat --gently` with exit status 255 and stderr:
			"""
			ERROR: Unable to kill gently... with a chainsaw!
			"""
		When I run `kill_the_cat`
		Then the stdout should contain "R.I.P."
		And the stderr should be empty
		When I run `kill_the_cat --gently`
		Then the stdout should be empty
		And the stderr should contain "ERROR: Unable to kill gently..."

Take a peek at `features/*.feature` for further examples and at `lib/aruba-doubles/cucumber.rb` for all step definitions.

### Mocking

Currently you can't check if a double was called at all, but hopefully this will be a feature in the future (patches are welcome!).

## Caveats

Aruba-Double won't work, if your command...

* calls other commands with absolute path, i.e. `/usr/local/kill_the_cat`
* defines its own PATH
* calls build-in commands from your shell like `echo` (but who want to stub that)

Of course you'll only see stdout and sterr from doubles if these aren't silenced by the calling command (like redirecting to /dev/null.)
Keep that in mind when you want to compare expected and acutal arguments.

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
