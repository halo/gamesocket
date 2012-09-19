require 'spec_helper'
require 'gamesocket/game_socket'

describe GameSocket::Socket do

  before do
    @it = GameSocket::Socket.new preferred_port: 33033, random_port_tries: 5
  end

  after do
    @it.reset!
  end

  describe '#initialize' do
    it "starts listening automatically on the preferred port" do
      @it.port.should == 33033
      @it.port.should >= 0
    end
  end

  describe '#start' do
    it "choses a random port if the preferred port is occupied" do
      @it.reset!
      occupier = UDPSocket.new
      occupier.bind '127.0.0.1', 33033
      @it.start!
      @it.port.should >= 0
      occupier.close
    end
  end

  describe '#port=' do
    it "binds to another port" do
      @it.port.should == 33033
      @it.port = 34000
      @it.port.should == 34000
    end
  end

  describe '#send_datagram' do
    before do
      @receiver = UDPSocket.new
      @receiver.bind(nil, 12345)
    end

    after do
      @receiver.close
    end

    it 'sends a datagram' do
      datagram = GameSocket::Datagram.new(payload: 'twelve bytes', endpoint: '127.0.0.1', port: 12345)
      @it.send_datagram(datagram).should == 12
      sleep 0.05
      @receiver.recvfrom(65507).first.should == 'twelve bytes'
    end

    it 'does not send an invalid datagram' do
      datagram = GameSocket::Datagram.new(payload: 'twelve bytes', endpoint: 'invalid IP', port: 12345)
      @it.send_datagram(datagram).should be_false
      sleep 0.05
      lambda { @receiver.recvfrom_nonblock(65507) }.should raise_error(Errno::EAGAIN)
    end

    it 'does not send an datagram with empty payload' do
      datagram = GameSocket::Datagram.new(payload: '', endpoint: 'invalid IP', port: 12345)
      @it.send_datagram(datagram).should be_false
      sleep 0.05
      lambda { @receiver.recvfrom_nonblock(65507) }.should raise_error(Errno::EAGAIN)
    end
  end

  describe '#receive_datagrams' do
    before do
      @sender = UDPSocket.new
      @sender.bind(nil, 12345)
      @sender.connect('127.0.0.1', 33033)
    end

    after do
      @sender.close
    end

    it 'yields nothing if there are no datagrams' do
      result = []
      @it.receive_datagrams { |datagram| result << datagram }
      result.should be_empty
    end

    it 'yields all datagrams' do
      @sender.send 'message one', 0
      @sender.send 'message two', 0
      @sender.send 'message three', 0
      result = []
      sleep 0.05
      @it.receive_datagrams { |datagram| result << datagram }
      result.map(&:payload).should == ['message one', 'message two', 'message three']
      result.map(&:endpoint).should == Array.new(3, '127.0.0.1')
      result.map(&:port).should == Array.new(3, 12345)
    end
  end

end