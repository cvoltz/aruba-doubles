module ArubaDoubles
  class Double
    attr_reader :stdout, :stderr, :exit_status, :expectations
    
    def initialize(expectations = {})
      @expectations = expectations
    end
    
    def could_receive(args, options = {})
      @expectations[args] = options
      self
    end
    
    def run(argv = ARGV)
      raise "Unexpected arguments: #{argv.inspect}" unless @expectations.has_key?(argv)
      @stdout = @expectations[argv][:stdout]
      @stderr = @expectations[argv][:stderr]
      @exit_status = @expectations[argv][:exit_status]
    end
  end
end
