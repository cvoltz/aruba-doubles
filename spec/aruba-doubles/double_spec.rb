require 'spec_helper'

describe ArubaDoubles::Double do
  describe '.setup' do
    before do
      @original_path = ENV['PATH']
      @bindir = '/tmp/foo'
      allow(ArubaDoubles::Double).to receive(:bindir).and_return(@bindir)
    end

    after do
      ENV['PATH'] = @original_path
    end

    it 'should prepend the doubles directory to PATH' do
      expect(ENV['PATH']).not_to match(%r(^#{@bindir}))
      ArubaDoubles::Double.setup
      expect(ENV['PATH']).to match(%r(^#{@bindir}))
    end

    it 'should change the path only once' do
      ArubaDoubles::Double.setup
      ArubaDoubles::Double.setup
      expect(ENV['PATH'].scan(@bindir).count).to eq(1)
    end
  end

  describe '.bindir' do
    it 'should create and return the temporary doubles directory' do
      bindir = '/tmp/foo'
      expect(Dir).to receive(:mktmpdir).once.and_return(bindir)
      expect(ArubaDoubles::Double.bindir).to eq(bindir)
      expect(ArubaDoubles::Double.bindir).to eq(bindir)
    end
  end

  describe '.teardown' do
    before do
      @bindir = '/tmp/foo'
    end

    it 'should delete all registered doubles' do
      doubles = []
      3.times { |i| doubles << double(i) }
      doubles.map{ |d| expect(d).to receive(:delete) }
      expect(ArubaDoubles::Double).to receive(:all).and_return(doubles)
      ArubaDoubles::Double.teardown
    end

    it 'should remove the doubles dir'
    it 'should not remove a non-empty doubles dir'

    it 'should remove the doubles dir from PATH' do
      allow(ArubaDoubles::Double).to receive(:bindir).and_return(@bindir)
      ArubaDoubles::Double.setup
      expect(ENV['PATH']).to match(%r(^#{@bindir}))
      ArubaDoubles::Double.teardown
      expect(ENV['PATH']).not_to match(%r(^#{@bindir}))
    end

    it 'should not restore PATH when unchanged' do
      original_path = '/foo:/bar:/baz'
      allow(ArubaDoubles::Double).to receive(:original_path).and_return('/foo:/bar:/baz')
      ArubaDoubles::Double.teardown
      expect(ENV['PATH']).not_to eq(original_path)
    end
  end

  describe '.new' do
    it 'should execute a given block in the doubles context' do
      double = ArubaDoubles::Double.new('bar') { def hi; "hi" end }
      expect(double).to respond_to(:hi)
    end

    it 'should raise error on missing filename'
    it 'should raise error on absolute filename'
  end

  describe '.find' do
    it 'should return a registered double by name' do
      allow(File).to receive(:open).and_return(double(:puts => nil, :close => nil))
      allow(FileUtils).to receive(:chmod)

      expect(ArubaDoubles::Double.find('registered_double')).to be_nil
      double = ArubaDoubles::Double.create('registered_double')
      expect(ArubaDoubles::Double.find('registered_double')).to eql(double)
    end
  end

  describe '.run' do
    before do
      @double = double('double', :run => nil)
      allow(ArubaDoubles::Double).to receive(:new).and_return(@double)
    end

    it 'should initialize a new double with the program name' do
      expect(ArubaDoubles::Double).to receive(:new).with('rspec')
      ArubaDoubles::Double.run
    end

    it 'should execute a block on that double when given' do
      block = Proc.new {}
      expect(@double).to receive(:instance_eval) do |&arg|
        expect(arg).to eq(block)
      end
      ArubaDoubles::Double.run(&block)
    end

    it 'should run the double' do
      expect(@double).to receive(:run)
      ArubaDoubles::Double.run
    end
  end

  describe '#run' do
    before do
      allow(ArubaDoubles::History).to receive(:new).and_return(double(:<< => nil))
      @double = ArubaDoubles::Double.new('foo',
        :puts => 'default stdout',
        :warn => 'default stderr',
        :exit => 23)
      @double.on %w[--hello],
        :puts => 'hello, world.',
        :warn => 'BOOOOM!',
        :exit => 42
      allow(@double).to receive_messages(:puts => nil, :warn => nil, :exit => nil)
    end

    it 'should append the call to the doubles history' do
      history = double('history')
      expect(history).to receive(:<<).with(%w[foo] + ARGV)
      expect(ArubaDoubles::History).to receive(:new).and_return(history)
      @double.run
    end

    context 'when ARGV does match' do
      def run_double
        @double.run %w[--hello]
      end

      it 'should print given stdout' do
        expect(@double).to receive(:puts).with('hello, world.')
        run_double
      end

      it 'should print given stderr' do
        expect(@double).to receive(:warn).with('BOOOOM!')
        run_double
      end

      it 'should return given exit code' do
        expect(@double).to receive(:exit).with(42)
        run_double
      end
    end

    context 'when ARGV does not match' do
      def run_double
        @double.run %w[--these --arguments --do --not --match]
      end

      it 'should print default stdout' do
        expect(@double).to receive(:puts).with('default stdout')
        run_double
      end

      it 'should print no stderr' do
        expect(@double).to receive(:warn).with('default stderr')
        run_double
      end

      it 'should exit with zero' do
        expect(@double).to receive(:exit).with(23)
        run_double
      end
    end
  end

  describe '.create' do
    before do
      @double = double('double', :create => nil)
      allow(ArubaDoubles::Double).to receive(:new).and_return(@double)
    end

    it 'should initialize a new double with the program name' do
      expect(ArubaDoubles::Double).to receive(:new).with('foo')
      ArubaDoubles::Double.create('foo')
    end

    it 'should execute a block on that double when given' do
      block = Proc.new {}
      expect(@double).to receive(:instance_eval) do |&arg|
        expect(arg).to eq(block)
      end
      ArubaDoubles::Double.create('foo', &block)
    end

    it 'should create the double' do
      expect(@double).to receive(:create)
      ArubaDoubles::Double.create('foo')
    end

    it 'should return the new double'
  end

  describe '#create' do
    before do
      allow(File).to receive(:open).and_return(double(:puts => nil, :close => nil))
      allow(FileUtils).to receive(:chmod)
      allow(ArubaDoubles::Double).to receive(:bindir).and_return('/tmp/foo')
    end

    it 'should create the executable command inside the doubles dir' do
      file = double('file', :puts => nil, :close => nil)
      expect(File).to receive(:open).with('/tmp/foo/bar', 'w').and_return(file)
      ArubaDoubles::Double.new('bar').create
    end

    it 'should make the file executable' do
      allow(File).to receive(:open).and_return(double(:puts => nil, :close => nil))
      filename = '/tmp/foo/bar'
      expect(FileUtils).to receive(:chmod).with(0755, filename)
      ArubaDoubles::Double.new('bar').create
    end

    it 'should register the double' do
      double = ArubaDoubles::Double.create('bar')
      expect(ArubaDoubles::Double.all).to include(double)
    end

    it 'should return self' do
      double = ArubaDoubles::Double.new('foo')
      expect(double.create).to eql(double)
    end

    it 'should execute a block on that double when given' do
      double = ArubaDoubles::Double.create('bar')
      block = Proc.new {}
      expect(double).to receive(:instance_eval) do |&arg|
        expect(arg).to eq(block)
      end
      double.create(&block)
    end
  end

  describe '#to_ruby' do
    before do
      @double = ArubaDoubles::Double.new('foo')
    end

    it 'should start with a she-bang line' do
      expect(@double.to_ruby).to include('#!/usr/bin/env ruby')
    end

    it 'should require the libs' do
      expect(@double.to_ruby).to include('require "aruba-doubles"')
    end

    it 'should include the doubles boilerplate' do
      expect(@double.to_ruby).to match(/^ArubaDoubles::Double.run\s+do.*end$/m)
    end

    it 'should include the defined outputs' do
      @double.on %w(--foo), :puts => 'bar'
      expect(@double.to_ruby).to include('on ["--foo"], {:puts=>"bar"}')
    end

    it 'should not include a block when no output is defined'
  end

  describe '#delete' do
    before do
      allow(File).to receive(:open).and_return(double(:puts => nil, :close => nil))
      allow(FileUtils).to receive(:chmod)
      allow(ArubaDoubles::Double).to receive(:bindir).and_return('/tmp/foo')
      @double = ArubaDoubles::Double.create('bar')
    end

    it 'should delete the executable file if it exists' do
      expect(File).to receive(:exists?).with('/tmp/foo/bar').and_return(true)
      expect(FileUtils).to receive(:rm).with('/tmp/foo/bar')
      @double.delete
    end

    it 'should deregister the double' do
      expect(ArubaDoubles::Double.all).to include(@double)
      @double.delete
      expect(ArubaDoubles::Double.all).not_to include(@double)
    end
  end
end
