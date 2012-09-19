# -*- encoding: utf-8 -*-
require 'gamesocket/extensions/object/blank'
require 'socket'

module GameSocket
  class UDPSocket < UDPSocket

    def bind(options={})
      return false unless options.is_a?(Hash)
      host = options[:host] || '0.0.0.0'
      port = options[:port] || self.class.random_port
      BasicSocket.do_not_reverse_lookup = true
      super(host, port)
    rescue Errno::EADDRINUSE, Errno::EINVAL
      # Port occupied
    rescue Errno::EADDRNOTAVAIL, SocketError
      # Port invalid
    end

    # Public: Identifies the port we're currently listening on.
    #
    # Returns: An Integer representing the port we're bound to, or nil if not bound at all.
    def port
      connect_address.ip_port
    rescue SocketError
      # Not bound to any local port
    rescue IOError
      # Socket has been closed
    end

    # Public: Closes the socket.
    #
    # Returns: Always nil.
    def close
      super
    rescue IOError
      # Already closed
    end

    # Internal: Returns a random port number. See RFC6335 for valid port ranges.
    def self.random_port
      rand(1024..49151)
    end

  end
end