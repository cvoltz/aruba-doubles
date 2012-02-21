Before do
  @old_aruba_doubles_dir = ENV['ARUBA_DOUBLES_DIR']
  ENV['ARUBA_DOUBLES_DIR'] = Dir.tmpdir
end

After('~@no-clobber') do
  remove_doubles if doubled?
end

After do
  clean_history
  ENV['ARUBA_DOUBLES_DIR'] = @old_aruba_doubles_dir
end

