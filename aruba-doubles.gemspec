# -*- encoding: utf-8 -*-
lib = ::File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aruba-doubles/version'

Gem::Specification.new do |s|
  s.name        = 'aruba-doubles'
  s.version     = ArubaDoubles::VERSION
  s.authors     = ['Björn Albers']
  s.email       = ['bjoernalbers@googlemail.com']
  s.description = 'Cucumber Steps to double Command Line Applications'
  s.summary     = "#{s.name}-#{s.version}"
  s.homepage    = "https://github.com/bjoernalbers/#{s.name}"
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'cucumber', '>= 1.0.2'
  s.add_dependency 'rspec', '>= 3.5.0'

  s.add_development_dependency 'rake', '>= 0.9.2.2'
  s.add_development_dependency 'aruba', '>= 0.4.6'
  s.add_development_dependency 'guard-cucumber', '>= 0.7.3'
  s.add_development_dependency 'guard-rspec', '>= 4.7'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
