require 'yaml'
require 'shellwords'

module ArubaDoubles
  class History
    HISTORY_FILE = "/tmp/aruba_doubles_history.yml"

    def log(program, argv)
      log_entries = commands
      log_entries << ([program] + argv)
      File.open(HISTORY_FILE, 'w') do |f|
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
      File.delete(HISTORY_FILE) if File.exists?(HISTORY_FILE)
    end

  private

    def commands
      log = YAML.load_file(HISTORY_FILE)
    rescue Errno::ENOENT
      log = []
    ensure
      log
    end
  end
end
