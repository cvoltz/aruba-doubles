Given /^a stubbed command "([^"]*)"$/ do |double|
  # Attention: This is just a proof-of-concept!

  content = '#!/bin/sh' # Some default content
  
  # Create executable double in temporary location
  bin_dir = Dir.mktmpdir
  double = File.expand_path(double, bin_dir)
  File.open(double, 'w') do |f|
    f.puts content
  end
  FileUtils.chmod(0755, double)
  
  # Hijack double into the path
  path = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
  ENV['PATH'] = ([bin_dir] + path).join(File::PATH_SEPARATOR)
end