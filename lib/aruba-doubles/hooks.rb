After('~@no-clobber') do
  remove_doubles if doubled?
end

After do
  clean_history
end

