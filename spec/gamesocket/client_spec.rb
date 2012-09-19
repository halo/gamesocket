require 'spec_helper'
require 'gamesocket/client'
require 'gamesocket/serializer'

describe GameSocket::Client do

  before do
    @it = GameSocket::Client.new id: 'abcdefgh', port: 12345, server_endpoint: '127.0.0.1', server_port: 33033
  end

  after do
    @it.reset!
  end

  describe '#initialize' do
    it 'assigns the parameters' do
      @it.id.size.should == 8
      @it.remote.endpoint.should == '127.0.0.1'
      @it.remote.port.should == 33033
      @it.port.should == 12345
    end
  end

  describe '#send_event' do
    before do
      @server = UDPSocket.new
      @server.bind(nil, 33033)
    end

    after do
      @server.close
    end

    it 'sends an event' do
      event = GameSocket::Event.new kind: :dance, data: { :some => 'data' }
      @it.send_event event
      sleep 0.05
      GameSocket::Serializer.unpack(@server.recvfrom(65507).first).should == { sender_id: 'abcdefgh', kind: :dance, data: { some: 'data' } }
    end
  end

  describe '#receive_events' do
    before do
      @server = UDPSocket.new
      @server.bind(nil, 33033)
      @server.connect('127.0.0.1', 12345)
    end

    after do
      @server.close
    end

    it 'yields nothing if there are no events' do
      result = []
      @it.receive_events { |event| result << event }
      result.should be_empty
    end

    it 'yields all events' do
      @server.send GameSocket::Serializer.pack({ sender_id: 'server', kind: :shot, data: { some: 'data' } }), 0
      @server.send GameSocket::Serializer.pack({ sender_id: 'server', kind: :blob, data: { some: 'more data' } }), 0
      sleep 0.05
      stack = []
      @it.receive_events { |event| stack << event }
      stack.size.should == 2
      stack[0].sender_id.should == 'server'
      stack[0].kind.should == :shot
      stack[0].data.should == { :some => 'data' }
      stack[1].sender_id.should == 'server'
      stack[1].kind.should == :blob
      stack[1].data.should == { :some => 'more data' }
    end
  end

end