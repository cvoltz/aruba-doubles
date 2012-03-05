require 'aruba-doubles'

World(ArubaDoubles)

Before do
  Double.setup
end

After do
  Double.teardown
end

Given /^I double `([^`]*)`$/ do |cmd|
  Double.create(cmd)
end

# ### Old stuff below
# 
# require 'aruba-doubles/hooks'
# require 'aruba-doubles/api'
# 
# World(ArubaDoubles::Api)
# 
# Given /^I could run `([^`]*)`$/ do |cmd|
#   create_double_by_cmd(cmd)
# end
# 
# Given /^I could run `([^`]*)` with any arguments$/ do |cmd|
#   create_double_by_cmd(cmd, :any_arguments => true)
# end
# 
# Given /^I could run `([^`]*)` with (stdout|stderr):$/ do |cmd, type, output|
#   create_double_by_cmd(cmd, type.to_sym => output)
# end
# 
# Given /^I could run `([^`]*)` with exit status (\d+)$/ do |cmd, exit|
#   create_double_by_cmd(cmd, :exit_status => exit.to_i)
# end
# 
# Given /^I could run `([^`]*)` with exit status (\d+) and (stdout|stderr):$/ do |cmd, exit, type, output|
#   create_double_by_cmd(cmd, :exit_status => exit.to_i, type.to_sym => output)
# end
# 
# Given /^the history is empty$/ do
#   clean_history
# end
# 
# Then /^`([^`]*)` should have been run$/ do |cmd|
#   assert_has_run(cmd)
# end
# 
# Then /^`([^`]*)` should not have been run$/ do |cmd|
#   assert_has_not_run(cmd)
# end
