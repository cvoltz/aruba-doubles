require 'aruba-doubles'

World(ArubaDoubles)

Before do
  Double.setup
end

After do
  Double.teardown
end

Given /^I double `([^`]*)`$/ do |cmd|
  double_cmd(cmd)
end

Given /^I double `([^`]*)` with stdout "([^"]*)"$/ do |cmd,stdout|
  double_cmd(cmd, :stdout => stdout)
end
