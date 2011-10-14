require 'aruba-doubles/api'

World(ArubaDoubles::Api)

Before do
  patch_original_path
end

After do
  # restore_original_path
end

Given /^a double of "([^"]*)"$/ do |double|
  content = '#!/bin/sh' # Some default content
  create_double(double, content)
end

Given /^a double of "([^"]*)" with stdout:$/ do |double, content|
  content = '#!/bin/sh' + "\n" + "echo #{content}"
  create_double(double, content)
end