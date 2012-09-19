# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'gamesocket/udp_socket'

describe GameSocket::UDPSocket do

  before do
    @port = ENV['GAMESOCKET_TEST_PORT1'].to_i
    @port.should > 0
    @it = GameSocket::UDPSocket.new
    @it.bind host: nil, port: @port
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
      @it.port.should == @port
    end
  end

end