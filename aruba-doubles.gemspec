# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'aruba-doubles'
  s.version     = '0.2.1'
  s.authors     = ["Björn Albers"]
  s.email       = ["bjoernalbers@googlemail.com"]
  s.description = 'Stub command line applications with Cucumber'
  s.summary     = "#{s.name}-#{s.version}"
  s.homepage    = "https://github.com/bjoernalbers/#{s.name}"

  s.add_dependency 'cucumber', '>= 1.0.2'

  s.add_development_dependency 'aruba', '>= 0.4.6'
  s.add_development_dependency 'guard-cucumber', '>= 0.7.3'
  s.add_development_dependency 'guard-rspec', '>= 0.5.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
