# -*- encoding: utf-8 -*-
require 'msgpack'

module GameSocket
  class Serializer

    def self.pack(data)
      data.to_msgpack
    end

    def self.unpack(data)
      MessagePack.unpack data
    end

  end
end
