module ArubaDoubles
  class Double
    class << self

      # Setup the doubles environment.
      def setup
        patch_path
      end

      # Teardown the doubles environment.
      def teardown
        delete_all
        restore_path
      end

      # Return the doubles directory.
      # @return [String]
      def bindir
        @bindir ||= Dir.mktmpdir
      end

      # Iterate over all registered doubles.
      def each
        all.each { |double| yield(double) }
      end

      # Return all registered doubles.
      # @return [Array<ArubaDoubles::Double>]
      def all
        @doubles ||= []
      end

      # Create a new double by JSON object
      # @return [ArubaDoubles::Double] the double
      def load_json(*args)
        double = self.new(File.basename($PROGRAM_NAME))
        double.load_json(*args)
        double
      end

    private

      attr_reader :original_path

      # Delete all registered doubles.
      def delete_all
        each(&:delete)
      end

      # Prepend doubles directory to PATH.
      def patch_path
        unless bindir_in_path?
          @original_path = ENV['PATH']
          ENV['PATH'] = [bindir, ENV['PATH']].join(File::PATH_SEPARATOR)
        end
      end

      # Remove doubles directory from PATH.
      def restore_path
        ENV['PATH'] = original_path if bindir_in_path?
      end

      # Check if PATH is already patched.
      # @return [Boolean]
      def bindir_in_path?
        ENV['PATH'].split(File::PATH_SEPARATOR).first == bindir
      end
    end

    attr_reader   :filename, :output, :matchers
    attr_accessor :default_output

    # Instantiate and register new double.
    # @return [ArubaDoubles::Double]
    def initialize(cmd, default_output = {})
      @filename = cmd
      @default_output = {:stdout => nil, :stderr => nil, :exit_status => nil}.merge(default_output)
      @output = @default_output
      @matchers = []
      self.class.all << self
    end

    # Add ARGV matcher with output.
    def on(argv, output = nil)
      @matchers << [argv, output || default_output]
    end 

    # Set output and log run.
    #
    # It sets the output based on ARGV match.
    # 
    # @return [Hash] the output
    def run(argv = ARGV)
      @matchers.each do |m|
        expected_argv, output = *m
        @output = @default_output.merge(output) if argv == expected_argv
      end
      @output
    end

    # Create the executable double.
    # @return [String] full path to the double.
    def create
      content = %Q{#!/usr/bin/env ruby
require 'aruba-doubles'
double = ArubaDoubles::Double.load_json %q{#{to_json}}
double.run
}
      fullpath = File.join(self.class.bindir, filename)
      f = File.open(fullpath, 'w')
      f.puts content
      f.close
      FileUtils.chmod(0755, File.join(self.class.bindir, filename))
    end

    # Delete the executable double.
    def delete
      fullpath = File.join(self.class.bindir, filename)
      FileUtils.rm(fullpath) if File.exists?(fullpath)
    end

    # Export the double (matchers and output) to JSON.
    # @return [String] JSON object
    def to_json
      JSON.pretty_generate(matchers)
    end

    # Load the double (matchers and output) from JSON.
    def load_json(json)
      @matchers = JSON.parse(json)
    end
  end
end

### Old stuff below

#     def self.run!(options = {})
#       double = self.new(options)
#       double.run
#       puts double.stdout if double.stdout
#       warn double.stderr if double.stderr
#       exit(double.exit_status) if double.exit_status
#     end
# 
#     def write_file(filename)
#       File.open(filename, 'w') do |f|
#         f.puts "#!/usr/bin/env ruby"
#         f.puts "# Doubled command line application by aruba-doubles\n"
#         f.puts "require 'rubygems'"
#         f.puts "require 'yaml'"
#         f.puts "require 'aruba-doubles/double'"
#         f.puts "require 'aruba-doubles/history'"
#         f.puts "ArubaDoubles::History.log(File.basename($0), ARGV)"
#         f.puts "expectations = YAML.load %Q{"
#         f.puts @expectations.to_yaml
#         f.puts "}"
#         f.puts "ArubaDoubles::Double.run! :any_arguments => #{@any_arguments}, :expectations => expectations"
#       end
#       FileUtils.chmod(0755, filename)
#     end
