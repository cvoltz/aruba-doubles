require 'aruba-doubles'

World(ArubaDoubles)

Before do
  ArubaDoubles::Double.setup
end

After do
  ArubaDoubles::Double.teardown
end

Given /^I double `([^`]*)`$/ do |cmd|
  double_cmd(cmd)
end

Given /^I double `([^`]*)` with "([^"]*)"$/ do |cmd,stdout|
  double_cmd(cmd, :stdout => stdout)
end

Given /^I double `([^`]*)` with stdout:$/ do |cmd,stdout|
  double_cmd(cmd, :stdout => stdout)
end

Given /^I double `([^`]*)` with exit status (\d+) and stdout:$/ do |cmd, exit_status, stdout|
  double_cmd(cmd, :stdout => stdout, :exit_status => exit_status.to_i)
end

Given /^I double `([^`]*)` with stderr:$/ do |cmd,stderr|
  double_cmd(cmd, :stderr => stderr)
end

Given /^I double `([^`]*)` with exit status (\d+) and stderr:$/ do |cmd, exit_status, stderr|
  double_cmd(cmd, :stderr => stderr, :exit_status => exit_status.to_i)
end

Given /^I double `([^`]*)` with exit status (\d+)$/ do |cmd, exit_status|
  double_cmd(cmd, :exit_status => exit_status.to_i)
end
