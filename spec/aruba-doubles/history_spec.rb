require 'spec_helper' 


describe ArubaDoubles::History do

  #TODO: Add examples to test the transactional stuff with PStore!

  it 'should initialize a PStore with the filename' do
    PStore.should_receive(:new).with('history.pstore')
    ArubaDoubles::History.new('history.pstore')
  end

  describe '#to_s' do
    before do
      @history = ArubaDoubles::History.new('history.pstore')
    end

    it 'should return an inspection of the entries' do
      @history.stub_chain(:to_a, :inspect).and_return('entries')
      @history.to_s.should eql('entries')
    end
  end
end
