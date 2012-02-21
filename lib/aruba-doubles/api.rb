### Old stuff below

# require 'aruba-doubles/double'
# require 'aruba-doubles/history'
# require 'shellwords'
# 
# module ArubaDoubles
#   module Api


#     
#     def create_double_by_cmd(cmd, options = {})
#       arguments = Shellwords.split(cmd)
#       filename = arguments.shift
#       create_double(filename, arguments, options)
#     end
#     



# 
#     def remove_doubles
#       restore_original_path
#       remove_doubles_dir
#     end
# 
#     def assert_has_run(cmd)
#       History.should have_run(cmd),
#         "#{cmd} was not found in history:\n#{History.to_s}\n"
#     end
# 
#     def assert_has_not_run(cmd)
#       History.should_not have_run(cmd),
#         "#{cmd} was found in history:\n#{History.to_s}\n"
#     end
# 
#     def clean_history
#       History.clean
#     end
# 
#   private
# 


#     def get_double(filename, arguments, options)
#       doubles[filename] ||= ArubaDoubles::Double.new(:any_arguments => options[:any_arguments])
#       doubles[filename].could_receive(arguments, options)
#     end


# 
#     def remove_doubles_dir
#       FileUtils.rm_r(@doubles_dir) unless @doubles_dir.nil?
#     end
#   end
# end
