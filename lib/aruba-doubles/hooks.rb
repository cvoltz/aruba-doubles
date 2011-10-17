After do
  restore_original_path
  remove_doubles
end

Before('@repeat_arguments') do
  @repeat_arguments = true
end
