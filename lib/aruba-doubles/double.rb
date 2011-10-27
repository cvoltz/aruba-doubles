class Double
  def stub(options = {})
    @stdout = options[:stdout]
  end
  
  def run!
    puts @stdout if @stdout
  end
end