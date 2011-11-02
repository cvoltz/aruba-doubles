require 'aruba-doubles/hooks'
require 'aruba-doubles/api'

World(ArubaDoubles::Api)

Given /^I could run `([^`]*)`$/ do |cmd|
  create_double_by_cmd(cmd)
end

Given /^I could run `([^`]*)` with (stdout|stderr):$/ do |cmd, type, output|
  create_double_by_cmd(cmd, type.to_sym => output)
end

Given /^I could run `([^`]*)` with exit status (\d+)$/ do |cmd, exit|
  create_double_by_cmd(cmd, :exit_status => exit.to_i)
end

Given /^I could run `([^`]*)` with exit status (\d+) and (stdout|stderr):$/ do |cmd, exit, type, output|
  create_double_by_cmd(cmd, :exit_status => exit.to_i, type.to_sym => output)
end
