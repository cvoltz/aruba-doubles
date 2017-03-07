require 'spec_helper' 

module ArubaDoubles
  describe History do
    before do
      allow(PStore).to receive(:new)
      @history = History.new('history.pstore')
    end

    #TODO: Add examples to test the transactional stuff with PStore!

    it 'should initialize a PStore with the filename' do
      expect(PStore).to receive(:new).with('history.pstore')
      History.new('history.pstore')
    end

    describe '#to_s' do
      it 'should return an inspection of the entries' do
        allow(@history).to receive_message_chain(:to_a, :inspect).and_return('entries')
        expect(@history.to_s).to eql('entries')
      end
    end

    describe '#to_pretty' do
      it 'should return a pretty representation to the entries' do
        entries = []
        entries << ['foo']
        entries << ['foo', '--bar']
        entries << ['foo', '--bar', 'hello, world.']
        allow(@history).to receive(:to_a).and_return(entries)
        expect(@history.to_pretty).to include('1  foo')
        expect(@history.to_pretty).to include('2  foo --bar')
        expect(@history.to_pretty).to include('3  foo --bar hello,\ world.')
      end
    end
  end
end
