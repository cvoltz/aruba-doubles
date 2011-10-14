require 'aruba-doubles/api'

World(ArubaDoubles::Api)

Before do
  patch_original_path
end

After do
  # restore_original_path
end

Given /^a double of "([^"]*)"$/ do |filename|
  create_double(filename)
end

Given /^a double of "([^"]*)" with stdout:$/ do |filename, output|
  create_double(filename, :stdout => output)
end

Given /^a double of "([^"]*)" with stderr:$/ do |filename, output|
  create_double(filename, :stderr => output)
end