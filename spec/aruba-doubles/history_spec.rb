require 'spec_helper' 

describe ArubaDoubles::History do
  before do
    @history = ArubaDoubles::History.new
    @history.clean
  end

  it "should be empty when cleaned" do
    @history.should be_empty
  end

  it "should check for commands by exact string" do
    @history.log('foo', [])
    @history.should have_run('foo')
  end

  it "should check for commands by regex" do
    @history.log('foo', [])
    @history.should have_run(/fo/)
  end

  it "should keep track of arguments as well" do
    @history.log('foo', ['--say', 'hello, world.'])
    @history.should_not have_run('foo')
    @history.should have_run('foo --say hello,\ world.')
  end

  it "should not overwrite previous history entries" do
    commands = %w{foo bar}
    commands.each { |c| @history.log(c, []) }
    commands.each { |c| @history.should have_run(c) }
  end
end
