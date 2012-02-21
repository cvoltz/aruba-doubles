require 'spec_helper'

describe Double, '#could_receive' do
  before do
    @double = Double.new
  end

  it "should set expected arguments like ARGV" do
    @double.could_receive(["--foo"], :stdout => "foo")
    @double.could_receive(["--bar"], :stdout => "bar")
    @double.run(["--foo"])
    @double.stdout.should eql("foo")
    @double.run(["--bar"])
    @double.stdout.should eql("bar")
  end

  it "should return self" do
    @double.could_receive([]).should be(@double)
  end
  
  it "should set defaults when called without options" do
    @double.could_receive([])
    @double.run([])
    @double.stdout.should be_nil
    @double.stderr.should be_nil
    @double.exit_status.should be_nil
  end

  it "should set optional stdout" do
    @double.could_receive([], :stdout => "hi")
    @double.run([])
    @double.stdout.should eql("hi")
  end

  it "should set optional stderr" do
    @double.could_receive([], :stderr => "HO!")
    @double.run([])
    @double.stderr.should eql("HO!")
  end
  
  it "should set optional exit status" do
    @double.could_receive([], :exit_status => 1)
    @double.run([])
    @double.exit_status.should eql(1)
  end
end

describe Double, '#run' do
  before do
    @double = Double.new
  end
  
  it "should read ARGV by default" do
    original_arguments = ARGV
    ARGV = ["--foo"]
    @double.could_receive(["--foo"], :stdout => "foo")
    @double.run
    @double.stdout.should eql("foo")
    ARGV = original_arguments
  end
  
  it "should raise when called with unexpected arguments" do
    lambda {
      @double.run(["--unexpected"])
    }.should raise_error('Unexpected arguments: ["--unexpected"]')
  end
end

describe Double do
  it "should be serializable" do
    double = Double.new
    double.could_receive([])
    double.could_receive(["--foo"], :stdout => "foo")
    double.could_receive(["--bar"], :stderr => "OOPS!", :exit_status => 255)
    loaded_double = Double.new(:expectations => double.expectations)
    loaded_double.run([])
    loaded_double.stdout.should be_nil
    loaded_double.stderr.should be_nil
    loaded_double.exit_status.should be_nil
    loaded_double.run(["--foo"])
    loaded_double.stdout.should eql("foo")
    loaded_double.stderr.should be_nil
    loaded_double.exit_status.should be_nil
    loaded_double.run(["--bar"])
    loaded_double.stdout.should be_nil
    loaded_double.stderr.should eql("OOPS!")
    loaded_double.exit_status.should eql(255)
  end
end

describe Double do
  describe '#run' do
    context 'with :any_arguments => true' do
      before do
        @double = Double.new(:any_arguments => true)
      end
    
      it 'should not raise an error for unexpected arguments' do
        lambda {
          @double.run %w(--unexpected arguments)
        }.should_not raise_error
      end
    
      it 'should return defaults for unexpected arguments' do
        @double.run %w(--unexpected arguments)
        @double.stdout.should Double.new.stdout
        @double.stderr.should Double.new.stderr
        @double.exit_status.should Double.new.exit_status
      end

      it 'should return explcit values for expected arguments' do
        @double.could_receive %(--expected argument),
          :stdout => 'foo',
          :stderr => 'bar',
          :exit_status => 1
        @double.run %(--expected argument)
        @double.stdout.should eql('foo')
        @double.stderr.should eql('bar')
        @double.exit_status.should eql(1)
      end
    end
  end
end
