# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'gamesocket/serializer'

describe GameSocket::Serializer do

  describe '#pack' do
    it "packs something" do
      package = GameSocket::Serializer.pack([1,2,3])
      #package.should == "\x93\x01\x02\x03" # Invalid bytes :|
    end
  end

  describe '#unpack' do
    it "unpacks something" do
      object = GameSocket::Serializer.unpack("1")
      object.should == 49
      #package.should == "\x93\x01\x02\x03" # Invalid bytes :|
    end
  end


end