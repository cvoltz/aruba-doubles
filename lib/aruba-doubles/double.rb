module ArubaDoubles
  class Double
    attr_reader :stdout, :stderr, :exit_status, :expectations
    
    def self.run!(options = {})
      double = self.new(options)
      double.run
      puts double.stdout if double.stdout
      warn double.stderr if double.stderr
      exit(double.exit_status) if double.exit_status
    end
    
    def initialize(options = {})
      @any_arguments = (options[:any_arguments] && true) || false
      @expectations = options[:expectations] || {}
    end
    
    def could_receive(args, options = {})
      @expectations[args] = options
      self
    end
    
    def run(argv = ARGV)
      if @expectations.has_key?(argv)
        @stdout = @expectations[argv][:stdout]
        @stderr = @expectations[argv][:stderr]
        @exit_status = @expectations[argv][:exit_status]
      else
        raise "Unexpected arguments: #{argv.inspect}" unless @any_arguments
      end
    end

    def write_file(filename)
      File.open(filename, 'w') do |f|
        f.puts "#!/usr/bin/env ruby"
        f.puts "# Doubled command line application by aruba-doubles\n"
        f.puts "require 'rubygems'"
        f.puts "require 'yaml'"
        f.puts "require 'aruba-doubles/double'"
        f.puts "require 'aruba-doubles/history'"
        f.puts "ArubaDoubles::History.log(File.basename($0), ARGV)"
        f.puts "expectations = YAML.load %Q{"
        f.puts @expectations.to_yaml
        f.puts "}"
        f.puts "ArubaDoubles::Double.run! :any_arguments => #{@any_arguments}, :expectations => expectations"
      end
      FileUtils.chmod(0755, filename)
    end
  end
end
