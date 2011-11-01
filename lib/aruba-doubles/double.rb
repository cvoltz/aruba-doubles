module ArubaDoubles
  class Double
    attr_reader :stdout, :stderr, :exit_status
    
    def initialize
      @args = {}
    end
    
    def could_receive(args, options = {})
      args = args.join(' ') if args.respond_to?(:join)
      @args[args] = options
      self
    end
    
    def run(argv = ARGV)
      argv = argv.join(' ')
      raise "Unexpected arguments" unless @args.has_key?(argv)
      @stdout = @args[argv][:stdout]
      @stderr = @args[argv][:stderr]
      @exit_status = @args[argv][:exit_status]
    end
    
    # def to_s
    #   s = "#{self.class}.run do\n"
    #   @args.each_pair { |k,v| s << "\tcould_receive \"#{k}\"" }
    #   s << "\nend"
    #   s
    # end
  end
end
