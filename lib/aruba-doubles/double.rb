class Double
  def stub(options = {})
    @stdout = options[:stdout]
    @stderr = options[:stderr]
    @exit_status = options[:exit_status]
  end
  
  def run!
    puts @stdout if @stdout
    warn @stderr if @stderr
    exit(@exit_status) if @exit_status
  end
end