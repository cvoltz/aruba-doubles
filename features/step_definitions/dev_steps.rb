Then /^the (stdout|stderr) should be empty$/ do |stdout_stderr|
  steps %Q{
    Then the #{stdout_stderr} should contain exactly:
			"""
			"""
  }
end
