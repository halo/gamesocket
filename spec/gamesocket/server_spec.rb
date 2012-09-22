require 'spec_helper'
require 'gamesocket/server'
require 'gamesocket/event'
require 'gamesocket/serializer'

describe GameSocket::Server do

  before do
    @it = GameSocket::Server.new id: 'blue_server', port: GameSocket::Test::server_port
    @client1 = UDPSocket.new
    @client2 = UDPSocket.new
    @client1.bind(nil, GameSocket::Test::client_port)
    @client2.bind(nil, GameSocket::Test::client2_port)
    @client1.connect('127.0.0.1', GameSocket::Test::server_port)
    @client2.connect('127.0.0.1', GameSocket::Test::server_port)
  end

  after do
    @it.reset!
    @client1.close
    @client2.close
  end

  describe '#initialize' do
    it 'assigns the parameters' do
      @it.port.should == GameSocket::Test::server_port
    end
  end

  describe '#send_event' do
    it 'sends nothing to unknown remotes' do
      event = GameSocket::Event.new sender_id: 'blue_server', kind: :hello, data: 'abcdefg'
      @it.send_event(event).should be_nil
    end

    it 'sends an event to a registered remote' do
      # Registering the client
      @client1.send GameSocket::Serializer.pack(sender_id: 'red_client', kind: :hello, data: nil), 0
      sleep 0.05
      @it.receive_events {}
      # Sending the event
      event = GameSocket::Event.new receiver_id: 'red_client', kind: :blue, data: { some: 'data' }
      @it.send_event event
      sleep 0.05
      # Making sure it arrived
      GameSocket::Serializer.unpack(@client1.recvfrom_nonblock(65507).first).should == { 'sender_id' => 'blue_server', 'kind' => 'blue', 'data' => { 'some' => 'data' } }
    end
  end

  describe '#broadcast' do
    it 'sends events to all registered remotes' do
      # Registering the clients
      @client1.send GameSocket::Serializer.pack({ 'sender_id' => 'white_client', kind: :hello }), 0
      @client2.send GameSocket::Serializer.pack({ 'sender_id' => 'green_client', kind: :hi }), 0
      sleep 0.05
      @it.receive_events {}
      # Broadcasting
      @it.broadcast GameSocket::Event.new kind: :blue, data: { :some => 'one' }
      sleep 0.05
      # Making sure it arrived
      GameSocket::Serializer.unpack(@client1.recvfrom_nonblock(65507).first).should == { 'sender_id' => 'blue_server', 'kind' => 'blue', 'data' => { 'some' => 'one' } }
      GameSocket::Serializer.unpack(@client2.recvfrom_nonblock(65507).first).should == { 'sender_id' => 'blue_server', 'kind' => 'blue', 'data' => { 'some' => 'one' } }
    end
  end

  describe '#receive_events' do
    it 'yields nothing if there are no events' do
      stack = []
      @it.receive_events { |event| stack << event }
      stack.should be_empty
    end

    it 'yields all events' do
      # Sending events
      @client1.send GameSocket::Serializer.pack({ sender_id: 'purple_client', 'kind' => :luke, 'data' => { 'some' => 'ice' } }), 0
      @client2.send GameSocket::Serializer.pack({ sender_id: 'yellow_client', 'kind' => :anakin, 'data' => { 'some' => 'fire' } }), 0
      @client2.send GameSocket::Serializer.pack({ sender_id: 'yellow_client', 'kind' => :lea, 'data' => { 'some' => 'water' } }), 0
      sleep 0.05
      stack = []
      # Receiving them
      @it.receive_events { |event| stack << event }
      stack.size.should == 3
      stack[0].sender_id.should == 'purple_client'
      stack[0].kind.should == :luke
      stack[0].data.should == { 'some' => 'ice' }
      stack[1].sender_id.should == 'yellow_client'
      stack[1].kind.should == :anakin
      stack[1].data.should == { 'some' => 'fire' }
      stack[2].sender_id.should == 'yellow_client'
      stack[2].kind.should == :lea
      stack[2].data.should == { 'some' => 'water' }
    end
  end

end