require 'gamesocket/datagram'

describe GameSocket::Datagram do

  describe '#initialize' do
    it 'assigns attributes' do
      remote = GameSocket::Datagram.new(payload: ' bob ', endpoint: '192.168.0.1', port: ' 1234 ')
      remote.payload.should == ' bob '
      remote.endpoint.should == '192.168.0.1'
      remote.port.should == 1234
      remote.should be_valid
    end
  end

  describe '#valid?' do
    it 'identifies a valid datagram' do
      GameSocket::Datagram.new(endpoint: '192.168.0.1', port: 1234).should be_valid
    end

    it 'identifies an invalid datagram because of an invalid IP' do
      GameSocket::Datagram.new(endpoint: '1923.168.0.1', port: 1234).should_not be_valid
    end

    it 'identifies an invalid datagram because of an invalid port' do
      GameSocket::Datagram.new(endpoint: '192.168.0.1', port: 7000000).should_not be_valid
    end
  end

end