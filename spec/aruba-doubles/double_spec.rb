require 'spec_helper'

describe ArubaDoubles::Double, '#could_receive' do
  before do
    @double = ArubaDoubles::Double.new
  end

  it "should set expected arguments" do
    @double.could_receive("--foo", :stdout => "foo")
    @double.could_receive("--bar", :stdout => "bar")
    @double.run(["--foo"])
    @double.stdout.should eql("foo")
    @double.run(["--bar"])
    @double.stdout.should eql("bar")
  end

  it "should return self" do
    @double.could_receive("").should be(@double)
  end
  
  it "should set defaults when called without options" do
    @double.could_receive("")
    @double.run([])
    @double.stdout.should be_nil
    @double.stderr.should be_nil
    @double.exit_status.should eql(0)
  end

  it "should set optional stdout" do
    @double.could_receive("", :stdout => "hi")
    @double.run([])
    @double.stdout.should eql("hi")
  end

  it "should set optional stderr" do
    @double.could_receive("", :stderr => "HO!")
    @double.run([])
    @double.stderr.should eql("HO!")
  end
  
  it "should set optional exit status" do
    @double.could_receive("", :exit_status => 1)
    @double.run([])
    @double.exit_status.should eql(1)
  end
end

describe ArubaDoubles::Double, '#run' do
  before do
    @double = ArubaDoubles::Double.new
  end
  
  it "should read ARGV by default" do
    original_arguments = ARGV
    ARGV = ["--foo"]
    @double.could_receive("--foo", :stdout => "foo")
    @double.run
    @double.stdout.should eql("foo")
    ARGV = original_arguments
  end
  
  it "should raise when called with unexpected arguments" do
    lambda {
      @double.run(["--unexpected"])
    }.should raise_error("Unexpected arguments")
  end
end
