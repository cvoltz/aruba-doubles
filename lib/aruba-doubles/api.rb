module ArubaDoubles
  module Api
    def doubles_dir
      @doubles_dir ||= Dir.mktmpdir
    end
    
    def patch_original_path
      @__aruba_doubles_original_path = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
      ENV['PATH'] = ([doubles_dir] + @__aruba_doubles_original_path).join(File::PATH_SEPARATOR)
    end

    def restore_original_path
      ENV['PATH'] = @__aruba_doubles_original_path.join(File::PATH_SEPARATOR)
    end

    def create_double(filename, options = {})
      double = File.expand_path(filename, doubles_dir)
      File.open(double, 'w') do |f|
        f.puts "#!/usr/bin/env ruby"
        f.puts "# Doubled command line application by aruba-double"
        f.puts "puts ([File.basename(__FILE__)] + ARGV).join(' ')" if @repeat_arguments
        f.puts "puts \"#{options[:stdout]}\"" if options[:stdout]
        f.puts "warn \"#{options[:stderr]}\"" if options[:stderr]
        f.puts "exit(#{options[:exit_status]})" if options[:exit_status]
      end
      FileUtils.chmod(0755, double)
    end
    
    def remove_doubles
      FileUtils.rm_r(doubles_dir) if File.directory?(doubles_dir)
    end
  end
end
