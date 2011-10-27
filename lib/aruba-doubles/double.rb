class Double
  def stub(options = {})
    @stdout = options[:stdout]
    @stderr = options[:stderr]
  end
  
  def run!
    puts @stdout if @stdout
    warn @stderr if @stderr
  end
end