require 'aruba-doubles/api'

World(ArubaDoubles::Api)

Before do
  patch_original_path
end

After do
  restore_original_path
  remove_doubles
end

Before('@repeat_arguments') do
  @repeat_arguments = true
end

Given /^a double of "([^"]*)"$/ do |file|
  create_double(file)
end

Given /^a double of "([^"]*)" with (stdout|stderr):$/ do |file, stdout_stderr, output|
  create_double(file, stdout_stderr.to_sym => output)
end

Given /^a double of "([^"]*)" with exit status (\d+)$/ do |file, exit|
  create_double(file, :exit_status => exit.to_i)
end

Given /^a double of "([^"]*)" with exit status (\d+) and (stdout|stderr):$/ do |file, exit, stdout_stderr, output|
  create_double(file, :exit_status => exit.to_i, stdout_stderr.to_sym => output)
end
