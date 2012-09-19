# -*- encoding: utf-8 -*-
require 'gamesocket/ipaddress'
require 'gamesocket/extensions/object/blank'

module GameSocket
  # A Datagram is the packet of the lowest level that Satellite is concerned with.
  # It contains the destination or sender address and a payload.
  class Datagram

    attr_reader :payload, :endpoint, :port

    def initialize(options={})
      @payload = options[:payload]
      self.endpoint = options[:endpoint]
      self.port = options[:port]
    end

    def valid?
      endpoint && port
    end

    def to_s
      "#<#{ 'Invalid ' unless valid? }Datagram #{payload.inspect} #{endpoint.inspect}:#{port.inspect}>"
    end

    private

    def endpoint=(new_endpoint)
      if IPAddress.valid? new_endpoint
        @endpoint = new_endpoint
      end
    end

    def port=(new_port)
      @port = (new_port.to_i if (1024..65535).member?(new_port.to_i))
    end

  end
end