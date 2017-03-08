Given /^I append the current working dir to my path$/ do
  append_environment_variable('PATH', '.')
end

Then /^the (stdout|stderr) should be empty$/ do |stdout_stderr|
  steps %Q{
    Then the #{stdout_stderr} should contain exactly:
			"""
			"""
  }
end
