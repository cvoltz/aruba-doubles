require 'yaml'
require 'shellwords'

module ArubaDoubles
  class History
    FILENAME = "aruba_doubles_history.yml"

    class << self
      def log(program, argv)
        common_history.log(program, argv)
      end
      
      def has_run?(cmd)
        common_history.has_run?(cmd)
      end
      
      def clean
        common_history.clean
      end

    private

      def common_history
        self.new(ENV['ARUBA_DOUBLES_DIR'])
      end
    end

    def initialize(dir = "/tmp") #TODO: change default to Dir.pwd!
      raise "Is not a directory: #{dir}" unless File.directory?(dir)
      @history_file = File.join(dir, FILENAME)
    end

    def log(program, argv)
      log_entries = commands
      log_entries << ([program] + argv)
      File.open(@history_file, 'w') do |f|
        f.puts log_entries.to_yaml
      end
    end

    def empty?
      commands.empty?
    end

    def has_run?(cmd)
      !commands.map { |c| Shellwords.join(c) }.grep(cmd).empty?
    end

    def clean
      File.delete(@history_file) if File.exists?(@history_file)
    end

    # TODO: Add example for this!
    def to_s
      commands.map { |c| Shellwords.join(c) }.join("\n")
    end

  private

    def commands
      log = YAML.load_file(@history_file)
    rescue Errno::ENOENT
      log = []
    ensure
      log
    end
  end
end
