module ArubaDoubles
  class Double
    attr_reader :stdout, :stderr, :exit_status
    
    def initialize
      @args = {}
    end
    
    def could_receive(args, options = {})
      @args[args] = options
      self
    end
    
    def run(argv = ARGV)
      argv = argv.join(' ')
      raise "Unexpected arguments" unless @args.has_key?(argv)
      @stdout = @args[argv][:stdout] if @args[argv][:stdout]
      @stderr = @args[argv][:stderr] if @args[argv][:stderr]
      @exit_status = @args[argv][:exit_status] if @args[argv][:exit_status]
      @exit_status = 0 unless @exit_status
    end
  end
end
