After do
  remove_doubles if doubled?
end

Before('@repeat_arguments') do
  warn(%{\e[35m    The @repeat_arguments tag is deprecated and will soon be removed. Please use the new mock feature to check for arguments (see README)!\e[0m})
  @repeat_arguments = true
end
