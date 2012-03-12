require 'spec_helper'

describe ArubaDoubles::Double do
  describe '.setup' do
    before do
      @original_path = ENV['PATH']
      @bindir = '/tmp/foo'
      ArubaDoubles::Double.stub(:bindir).and_return(@bindir)
    end

    after do
      ENV['PATH'] = @original_path
    end

    it 'should prepend the doubles directory to PATH' do
      ENV['PATH'].should_not match(%r(^#{@bindir}))
      ArubaDoubles::Double.setup
      ENV['PATH'].should match(%r(^#{@bindir}))
    end

    it 'should change the path only once' do
      ArubaDoubles::Double.setup
      ArubaDoubles::Double.setup
      ENV['PATH'].scan(@bindir).count.should eq(1)
    end
  end

  describe '.bindir' do
    it 'should create and return the temporary doubles directory' do
      bindir = '/tmp/foo'
      Dir.should_receive(:mktmpdir).once.and_return(bindir)
      ArubaDoubles::Double.bindir.should eq(bindir)
      ArubaDoubles::Double.bindir.should eq(bindir)
    end
  end

  describe '.teardown' do
    before do
      @bindir = '/tmp/foo'
    end

    it 'should delete all registered doubles' do
      doubles = []
      3.times { |i| doubles << double(i) }
      doubles.map{ |d| d.should_receive(:delete) }
      ArubaDoubles::Double.should_receive(:all).and_return(doubles)
      ArubaDoubles::Double.teardown
    end

    it 'should remove the doubles dir'
    it 'should not remove a non-empty doubles dir'

    it 'should remove the doubles dir from PATH' do
      ArubaDoubles::Double.stub(:bindir).and_return(@bindir)
      ArubaDoubles::Double.setup
      ENV['PATH'].should match(%r(^#{@bindir}))
      ArubaDoubles::Double.teardown
      ENV['PATH'].should_not match(%r(^#{@bindir}))
    end

    it 'should not restore PATH when unchanged' do
      original_path = '/foo:/bar:/baz'
      ArubaDoubles::Double.stub(:original_path).and_return('/foo:/bar:/baz')
      ArubaDoubles::Double.teardown
      ENV['PATH'].should_not eq(original_path)
    end
  end

  describe '.create' do
    before do
      @rspec_double = double('foo')
    end

    it 'should create a double by program name' do
      @rspec_double.stub(:create)
      ArubaDoubles::Double.should_receive(:new).with('foo').and_return(@rspec_double)
      ArubaDoubles::Double.create('foo')
    end

    #it 'should forward options to Double#create' do
    #  ArubaDoubles::Double.stub(:new).and_return(rspec_double)
    #end

    it 'should create an executable double' do
      rspec_double = double('foo')
      rspec_double.should_receive(:create)
      ArubaDoubles::Double.should_receive(:new).with('foo --bar').and_return(rspec_double)
      ArubaDoubles::Double.create('foo --bar')
    end
  end

  describe '.new' do
    it 'should register the double' do
      ArubaDoubles::Double.all.should be_empty
      d = ArubaDoubles::Double.new('bar')
      ArubaDoubles::Double.all.should eq([d])
    end

    it 'should initialize all output attributes with nil' do
      output = ArubaDoubles::Double.new('foo').output
      output.should eql({:stdout => nil, :stderr => nil, :exit_status => nil})
    end

    it 'should raise error on missing filename'
    it 'should raise error on absolute filename'
    it 'should allow to set default output' do
      output = {:stdout => 'STDOUT', :stderr => 'STDERR', :exit_status => 1}
      double = ArubaDoubles::Double.new('foo', output)
      double.default_output.should eql(output)
    end
  end

  describe '#run' do
    before do
      @double = ArubaDoubles::Double.new('foo')
    end

    it 'should merge default output with output' do
      output = {:stdout => 'STDOUT', :stderr => 'STDERR', :exit_status => 1}
      @double.default_output = output
      @double.on [], {:stdout => 'hello, world.'}
      @double.run([]).should eql(output.merge({:stdout => 'hello, world.'}))
    end

    it 'should set output based on first matching argv' do
      @double.on %w[--hello], {:stdout => 'hello'}
      @double.on %w[--world], {:stdout => 'world'}
      @double.run(%w[--hello])[:stdout].should eql('hello')
      @double.run(%w[--world])[:stdout].should eql('world')
    end

    it 'should set output to default when no matching argv found' do
      @double.on %w[--hello world], {:stdout => 'hello, world.'}
      @double.run([]).should eql(@double.default_output)
    end
  end

  describe '#create' do
    it 'should create the executable command inside the doubles dir' do
      file = double('file', :puts => nil, :close => nil)
      ArubaDoubles::Double.stub(:bindir).and_return('/tmp/foo')
      File.should_receive(:open).with('/tmp/foo/bar', 'w').and_return(file)
      FileUtils.stub(:chmod)
      ArubaDoubles::Double.new('bar').create
    end

    it 'should make the file executable' do
      ArubaDoubles::Double.stub(:bindir).and_return('/tmp/foo')
      File.stub(:open).and_return(stub(:puts => nil, :close => nil))

      filename = '/tmp/foo/bar'
      FileUtils.should_receive(:chmod).with(0755, filename)

      ArubaDoubles::Double.new('bar').create
    end
  end

  describe '#delete' do
    it 'should delete the executable file if it exists' do
      ArubaDoubles::Double.stub(:bindir).and_return('/tmp/foo')
      double = ArubaDoubles::Double.new('bar')
      File.should_receive(:exists?).with('/tmp/foo/bar').and_return(true)
      FileUtils.should_receive(:rm).with('/tmp/foo/bar')
      double.delete
    end
  end
end

### old stuff below

# describe Double, '#could_receive' do
#   before do
#     @double = Double.new
#   end
# 
#   it "should set expected arguments like ARGV" do
#     @double.could_receive(["--foo"], :stdout => "foo")
#     @double.could_receive(["--bar"], :stdout => "bar")
#     @double.run(["--foo"])
#     @double.stdout.should eql("foo")
#     @double.run(["--bar"])
#     @double.stdout.should eql("bar")
#   end
# 
#   it "should return self" do
#     @double.could_receive([]).should be(@double)
#   end
#   
#   it "should set defaults when called without options" do
#     @double.could_receive([])
#     @double.run([])
#     @double.stdout.should be_nil
#     @double.stderr.should be_nil
#     @double.exit_status.should be_nil
#   end
# 
#   it "should set optional stdout" do
#     @double.could_receive([], :stdout => "hi")
#     @double.run([])
#     @double.stdout.should eql("hi")
#   end
# 
#   it "should set optional stderr" do
#     @double.could_receive([], :stderr => "HO!")
#     @double.run([])
#     @double.stderr.should eql("HO!")
#   end
#   
#   it "should set optional exit status" do
#     @double.could_receive([], :exit_status => 1)
#     @double.run([])
#     @double.exit_status.should eql(1)
#   end
# end
# 
# describe Double, '#run' do
#   before do
#     @double = Double.new
#   end
#   
#   it "should read ARGV by default" do
#     original_arguments = ARGV
#     ARGV = ["--foo"]
#     @double.could_receive(["--foo"], :stdout => "foo")
#     @double.run
#     @double.stdout.should eql("foo")
#     ARGV = original_arguments
#   end
#   
#   it "should raise when called with unexpected arguments" do
#     lambda {
#       @double.run(["--unexpected"])
#     }.should raise_error('Unexpected arguments: ["--unexpected"]')
#   end
# end
# 
# describe Double do
#   it "should be serializable" do
#     double = Double.new
#     double.could_receive([])
#     double.could_receive(["--foo"], :stdout => "foo")
#     double.could_receive(["--bar"], :stderr => "OOPS!", :exit_status => 255)
#     loaded_double = Double.new(:expectations => double.expectations)
#     loaded_double.run([])
#     loaded_double.stdout.should be_nil
#     loaded_double.stderr.should be_nil
#     loaded_double.exit_status.should be_nil
#     loaded_double.run(["--foo"])
#     loaded_double.stdout.should eql("foo")
#     loaded_double.stderr.should be_nil
#     loaded_double.exit_status.should be_nil
#     loaded_double.run(["--bar"])
#     loaded_double.stdout.should be_nil
#     loaded_double.stderr.should eql("OOPS!")
#     loaded_double.exit_status.should eql(255)
#   end
# end
# 
# describe Double do
#   describe '#run' do
#     context 'with :any_arguments => true' do
#       before do
#         @double = Double.new(:any_arguments => true)
#       end
#     
#       it 'should not raise an error for unexpected arguments' do
#         lambda {
#           @double.run %w(--unexpected arguments)
#         }.should_not raise_error
#       end
#     
#       it 'should return defaults for unexpected arguments' do
#         @double.run %w(--unexpected arguments)
#         @double.stdout.should Double.new.stdout
#         @double.stderr.should Double.new.stderr
#         @double.exit_status.should Double.new.exit_status
#       end
# 
#       it 'should return explcit values for expected arguments' do
#         @double.could_receive %(--expected argument),
#           :stdout => 'foo',
#           :stderr => 'bar',
#           :exit_status => 1
#         @double.run %(--expected argument)
#         @double.stdout.should eql('foo')
#         @double.stderr.should eql('bar')
#         @double.exit_status.should eql(1)
#       end
#     end
#   end
# end
