# -*- encoding: utf-8 -*-
require 'gamesocket/extensions/object/blank'
require 'gamesocket/ipaddress'

module GameSocket
  class Remote

    attr_reader :id, :endpoint, :port

    def initialize(options={})
      @id = options[:id].presence
      self.endpoint = options[:endpoint]
      self.port = options[:port]
    end

    def valid?
      id && endpoint && port
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