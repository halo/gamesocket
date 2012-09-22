# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'gamesocket/udp_socket'

describe GameSocket::UDPSocket do

  before do
    @it = GameSocket::UDPSocket.new
    @it.bind host: nil, port: GameSocket::Test::server_port
  end

  after do
    @it.close
  end

  describe '#initialize' do
    it "doesn't freak out with an invalid port" do
      socket = GameSocket::UDPSocket.new
      socket.bind(-1000).should be_false
    end
  end

  describe '#port' do
    it 'knows the port' do
      @it.port.should == GameSocket::Test::server_port
    end
  end

end