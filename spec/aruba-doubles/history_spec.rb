require 'spec_helper' 

describe ArubaDoubles::History do
  before do
    @history = ArubaDoubles::History.new(Dir.tmpdir)
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

describe ArubaDoubles::History, '#initialize' do
  it "should accept a directory name for the history file" do
    dir = Dir.tmpdir
    history_file = File.join(dir, ArubaDoubles::History::FILENAME)
    history = ArubaDoubles::History.new(dir)
    history.clean
    File.should_not exist(history_file)
    history.log('foo', [])
    File.should exist(history_file), history_file
  end

  it "should use the current working dir by default" do
    history_file = File.join(Dir.pwd, ArubaDoubles::History::FILENAME)
    history = ArubaDoubles::History.new
    history.clean
    File.should_not exist(history_file)
    history.log('foo', [])
    File.should exist(history_file), history_file
    history.clean
  end

  it "should raise when parameter is no directory" do
    lambda{
      ArubaDoubles::History.new("nosuchdirectory")
    }.should raise_error
  end
end

describe ArubaDoubles::History do
  before do
    @old_aruba_doubles_dir = ENV['ARUBA_DOUBLES_DIR']
    ENV['ARUBA_DOUBLES_DIR'] = Dir.tmpdir
    common_history_file = File.join(ENV['ARUBA_DOUBLES_DIR'],
      ArubaDoubles::History::FILENAME)
    File.delete(common_history_file) if File.exists?(common_history_file)
  end

  describe '.log' do
    it "should write history file to ENV['ARUBA_DOUBLES_DIR']" do
      History.new(ENV['ARUBA_DOUBLES_DIR']).should_not have_run('foo')
      History.log('foo', [])
      History.new(ENV['ARUBA_DOUBLES_DIR']).should have_run('foo')
    end
  end

  describe '.has_run?' do
    it "should read history file from ENV['ARUBA_DOUBLES_DIR']" do
      History.should_not have_run('foo')
      History.new(ENV['ARUBA_DOUBLES_DIR']).log('foo', [])
      History.should have_run('foo')
    end
  end

  describe '.clean' do
    it "should delete the history file in ENV['ARUBA_DOUBLES_DIR']" do
      History.log('foo', [])
      History.should have_run('foo')
      History.clean
      History.should_not have_run('foo')
    end
  end

  after do
    ENV['ARUBA_DOUBLES_DIR'] = @old_aruba_doubles_dir
  end
end
