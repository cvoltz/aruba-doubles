module ArubaDoubles
  module Api
    def bin_dir
      @bin_dir ||= Dir.mktmpdir
    end
    
    def patch_original_path
      path = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
      ENV['PATH'] = ([bin_dir] + path).join(File::PATH_SEPARATOR)
    end
    
    def create_double(filename, options = {})
      double = File.expand_path(filename, bin_dir)
      File.open(double, 'w') do |f|
        f.puts '#!/usr/bin/env ruby'
        f.puts "puts ([File.basename(__FILE__)] + ARGV).join(' ')" if
          @repeat_arguments
        f.puts "puts \"#{options[:stdout]}\"" if options[:stdout]
        f.puts "warn \"#{options[:stderr]}\"" if options[:stderr]
        f.puts "exit(#{options[:exit_status]})" if options[:exit_status]
      end
      FileUtils.chmod(0755, double)
    end
  end
end
