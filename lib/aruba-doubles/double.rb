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

      # Create an executable double.
      def create(cmd)
        new(cmd).create
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

    attr_reader :filename

    # Instiate and register a new double.
    # @returns [ArubaDoubles::Double]
    def initialize(cmd, options = {})
      @filename = cmd
      self.class.all << self
    end

    def create
      fullpath = File.join(self.class.bindir, filename)
      f = File.open(fullpath, 'w')
      # test this!
      f.puts "#!/usr/bin/env ruby"
      f.close
      # test this!
      FileUtils.chmod(0755, File.join(self.class.bindir, filename))
    end

    def delete
      fullpath = File.join(self.class.bindir, filename)
      FileUtils.rm(fullpath) if File.exists?(fullpath)
    end
  end
end

### Old stuff below

# module ArubaDoubles
#   class Double
#     attr_reader :stdout, :stderr, :exit_status, :expectations
#     
#     def self.run!(options = {})
#       double = self.new(options)
#       double.run
#       puts double.stdout if double.stdout
#       warn double.stderr if double.stderr
#       exit(double.exit_status) if double.exit_status
#     end
#     
#     def initialize(options = {})
#       @any_arguments = (options[:any_arguments] && true) || false
#       @expectations = options[:expectations] || {}
#     end
#     
#     def could_receive(args, options = {})
#       @expectations[args] = options
#       self
#     end
#     
#     def run(argv = ARGV)
#       if @expectations.has_key?(argv)
#         @stdout = @expectations[argv][:stdout]
#         @stderr = @expectations[argv][:stderr]
#         @exit_status = @expectations[argv][:exit_status]
#       else
#         raise "Unexpected arguments: #{argv.inspect}" unless @any_arguments
#       end
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
#   end
# end
