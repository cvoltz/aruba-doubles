module ArubaDoubles
  module Api
    def bin_dir
      @bin_dir ||= Dir.mktmpdir
    end
    
    def patch_original_path
      path = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
      ENV['PATH'] = ([bin_dir] + path).join(File::PATH_SEPARATOR)
    end
    
    def create_double(filename, content)
      double = File.expand_path(filename, bin_dir)
      File.open(double, 'w') do |f|
        f.puts content
      end
      FileUtils.chmod(0755, double)
    end
  end
end