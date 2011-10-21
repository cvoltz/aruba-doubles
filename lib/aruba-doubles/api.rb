module ArubaDoubles
  module Api
    def doubled?
      !@doubles_dir.nil?
    end
    
    def create_double(file, options = {})
      unless doubled?
        create_doubles_dir
        patch_original_path
      end
      write_double(file, options)
    end
    
    def remove_doubles
      restore_original_path
      remove_doubles_dir
    end

  private

    def create_doubles_dir
      @doubles_dir = Dir.mktmpdir
    end

    def patch_original_path
      @__aruba_doubles_original_path = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
      ENV['PATH'] = ([@doubles_dir] + @__aruba_doubles_original_path).join(File::PATH_SEPARATOR)
    end

    def write_double(command_line, options = {})
      args = command_line.split
      filename = args.shift
      double = File.expand_path(filename, @doubles_dir)
      File.open(double, 'w') do |f|
        f.puts "#!/usr/bin/env ruby"
        f.puts "# Doubled command line application by aruba-doubles\n"
        f.puts "unless ARGV.to_s == \"#{args}\""
        f.puts "  warn \"expected: #{filename} #{args}\""
        f.puts "  warn \"     got: #{filename} \#{ARGV}\""
        f.puts "  exit(1)"
        f.puts "end"
        f.puts "puts ([File.basename(__FILE__)] + ARGV).join(' ')" if @repeat_arguments
        f.puts "puts \"#{options[:stdout]}\"" if options[:stdout]
        f.puts "warn \"#{options[:stderr]}\"" if options[:stderr]
        f.puts "exit(#{options[:exit_status]})" if options[:exit_status]
      end
      FileUtils.chmod(0755, double)
    end

    def restore_original_path
      ENV['PATH'] = @__aruba_doubles_original_path.join(File::PATH_SEPARATOR) unless doubled?
    end

    def remove_doubles_dir
      FileUtils.rm_r(@doubles_dir) unless @doubles_dir.nil?
    end
  end
end
