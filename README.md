Double command line applications in your Cucumber features

## Motivation

Let's say you develop a command line application ([BDD](http://en.wikipedia.org/wiki/Behavior_Driven_Development)-style with [Cucumber](http://cukes.info/) and [Aruba](https://github.com/cucumber/aruba)) which itself relys on other CLI stuff that makes testing harder (i.e. it calls under certain conditions `kill_a_random_cat` or `launch_nukes`... Don't do that in your tests!).
Stubbing and mocking in your Cucumber features is usually not recommended (in order to test "the full stack"), but in some cases it could make your life easier (Your cat will thank you later.)
Aruba-Double lets you stub out those evil commands in your scenarios by injecting temporary doubles in your system (it will hijack your PATH during tests).

(Note: This little Gem isn't an official part of Aruba but it works as a complement, so they'll play hopefully nicely together.)

## Usage

If you have a `Gemfile`, add `aruba-doubles`. Otherwise, install it like this:

    gem install aruba-doubles

Then, `require` the library in one of your ruby files under `features/support` (e.g. `env.rb`)

    require 'aruba-doubles/cucumber'

Take a peek at `features/*.feature` for some examples and look in `lib/aruba-doubles/cucumber.rb` for all step definitions.

## Caveats

Aruba-Double won't work, if your command...

* calls other commands with absolute path, i.e. `/usr/local/kill_a_random_cat`
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
