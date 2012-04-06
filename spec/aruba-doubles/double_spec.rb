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

  describe '.load_json' do
    it 'should initialize a double with the executables basename' do
      json_obj = double('json_obj')
      double_obj = double('double_obj')
      double_obj.stub(:load_json)
      ArubaDoubles::Double.should_receive(:new).with('rspec').and_return(double_obj)
      ArubaDoubles::Double.load_json(json_obj)
    end

    it 'should load the json into a new double object' do
      json_obj = double('json_obj')
      double_obj = double('double_obj')
      double_obj.should_receive(:load_json).with(json_obj)
      ArubaDoubles::Double.should_receive(:new).and_return(double_obj)

      ArubaDoubles::Double.load_json(json_obj)
    end
    it 'should return the double object'
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

    it 'should read ARGV by default' #TODO: test this!
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
