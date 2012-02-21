Given /^I append the current working dir to my path$/ do
  ENV['PATH'] = [ENV['PATH'], '.'].join(File::PATH_SEPARATOR)
end

### Old stuff below...

Then /^the doubles directory should not exist$/ do
  @doubles_dir.should be_nil
end

Then /^the path should include (\d+) doubles directory$/ do |count|
  ENV['PATH'].split(File::PATH_SEPARATOR).count(@doubles_dir).should eql(count.to_i)
end

When /^I keep the doubles directory in mind$/ do
  @@previous_doubles_dir = @doubles_dir
end

Then /^the previous doubles directory should not exist$/ do
  File.should_not be_exist(@@previous_doubles_dir)
end

Then /^the previous doubles directory should exist$/ do
  File.should be_exist(@@previous_doubles_dir)
end

Then /^the (stdout|stderr) should be empty$/ do |stdout_stderr|
  steps %Q{
    Then the #{stdout_stderr} should contain exactly:
			"""
			"""
  }
end


