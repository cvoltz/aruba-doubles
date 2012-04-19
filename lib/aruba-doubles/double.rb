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

      # Initialize a new double and run it.
      #
      # It accepts an optional block to setup define the doubles output.
      def run(&block)
        double = new(File.basename($PROGRAM_NAME))
        double.instance_eval(&block) if block_given?
        double.run
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

    attr_reader   :filename, :output, :matchers

    # Instantiate and register new double.
    # @return [ArubaDoubles::Double]
    def initialize(cmd, default_output = {}, &block)
      @filename = cmd
      @output = {:stdout => nil, :stderr => nil, :exit_status => nil}.merge(default_output)
      @matchers = []
      self.class.all << self
      self.instance_eval(&block) if block_given?
    end

    # Add ARGV matcher with output.
    def on(argv, output = nil)
      @matchers << [argv, output || default_output]
    end

    # Run the double.
    #
    # This will actually display any outputs if defined and exit.
    def run(argv = ARGV)
      @matchers.each do |m|
        expected_argv, output = *m
        @output = output if argv == expected_argv
      end
      puts @output[:stdout] if @output[:stdout]
      warn @output[:stderr] if @output[:stderr]
      exit @output[:exit_status] if @output[:exit_status]
    end

    # Create the executable double.
    # @return [String] full path to the double.
    def create
      content = self.to_ruby
      fullpath = File.join(self.class.bindir, filename)
      #puts "creating double: #{fullpath} with content:\n#{content}" # debug
      f = File.open(fullpath, 'w')
      f.puts content
      f.close
      FileUtils.chmod(0755, File.join(self.class.bindir, filename))
    end

    # Export the double to executable Ruby code.
    #
    # @return [String] serialized double
    def to_ruby
      ruby = ['#!/usr/bin/env ruby']
      ruby << "$: << '#{File.expand_path('..', File.dirname(__FILE__))}'"
      ruby << 'require "aruba-doubles"'
      ruby << 'ArubaDoubles::Double.run do'
      @matchers.each { |argv,output| ruby << "  on #{argv.inspect}, #{output.inspect}" }
      ruby << 'end'
      ruby.join("\n")
    end

    # Delete the executable double.
    def delete
      fullpath = File.join(self.class.bindir, filename)
      FileUtils.rm(fullpath) if File.exists?(fullpath)
    end
  end
end
