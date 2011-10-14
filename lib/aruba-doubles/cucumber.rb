require 'aruba-doubles/api'

World(ArubaDoubles::Api)

Before do
  patch_original_path
end

Before('@repeat_arguments') do
  @repeat_arguments = true
end

After do
  # TODO: restore_original_path
  # TODO: clean-up (delete doubles and tmp dirs)
end

Given /^a double of "([^"]*)"$/ do |filename|
  create_double(filename)
end

Given /^a double of "([^"]*)" with (stdout|stderr):$/ do
    |filename, stdout_stderr, output|
  create_double(filename, stdout_stderr.to_sym => output)
end

Given /^a double of "([^"]*)" with exit status (\d+)$/ do
    |filename, exit_status|
  create_double(filename, :exit_status => exit_status.to_i)
end

Given /^a double of "([^"]*)" with exit status (\d+) and (stdout|stderr):$/ do
    |filename, exit_status, stdout_stderr, output|
  create_double(filename, :exit_status => exit_status.to_i,
    stdout_stderr.to_sym => output)
end

