require 'spec_helper' 


describe ArubaDoubles::History do

  #TODO: Add examples to test the transactional stuff with PStore!

  it 'should initialize a PStore with the filename' do
    PStore.should_receive(:new).with('history.pstore')
    ArubaDoubles::History.new('history.pstore')
  end
end
