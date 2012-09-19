# -*- encoding: utf-8 -*-
require 'gamesocket/remote'

describe GameSocket::Remote do

  describe '#initialize' do
    it 'assigns attributes' do
      remote = GameSocket::Remote.new(id: 'bob', endpoint: '192.168.0.1', port: '1234')
      remote.id.should == 'bob'
      remote.endpoint.should == '192.168.0.1'
      remote.port.should == 1234
      remote.should be_valid
    end

    it 'handles an invalid id' do
      remote = GameSocket::Remote.new(id: '', endpoint: '192.168.0.1', port: 1234)
      remote.id.should be_nil
      remote.endpoint.should == '192.168.0.1'
      remote.port.should == 1234
      remote.should_not be_valid
    end

    it 'handles an invalid endpoint' do
      remote = GameSocket::Remote.new(id: 'bob', endpoint: 'definitaly invalid', port: 1234)
      remote.id.should == 'bob'
      remote.endpoint.should be_nil
      remote.port.should == 1234
      remote.should_not be_valid
    end

    it 'handles an invalid port' do
      remote = GameSocket::Remote.new(id: 'bob', endpoint: '192.168.0.1', port: 'invalid')
      remote.id.should == 'bob'
      remote.endpoint.should == '192.168.0.1'
      remote.port.should be_nil
      remote.should_not be_valid
    end
  end

end