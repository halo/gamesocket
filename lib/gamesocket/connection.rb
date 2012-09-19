# -*- encoding: utf-8 -*-
require 'gamesocket/game_socket'
require 'satellite/extensions/core/object/random'


module GameSocket
  class Connection
    attr_reader :id

    def initialize(options={})
      @id = options[:id] || random_id
      @socket = GameSocket.new preferred_port: options[:port]
    end

    def port
      @socket.port
    end

    def port=(new_port)
      @socket.port = new_port
    end

    def flush
      @socket.flush
    end

    # Internal: Free the socket. Useful for testing.
    def reset!
      @socket.reset!
    end

    # Internal: Start listening on the socket. Useful for testing.
    def start
      @socket.start!
    end

    private

    def receive_remotes_and_payloads(&block)
      @socket.receive_datagrams do |datagram|
        payload = Marshal.load(datagram.payload)
        unless payload.is_a?(Hash)
          Log.error "Network port received invalid event payload: #{payload.inspect}"
          next
        end
        remote = Remote.new(id: payload[:sender_id], endpoint: datagram.endpoint, port: datagram.port)
        if remote.valid?
          yield remote, payload
        else
          Log.error "Network port received packet from invalid remote: #{remote.inspect}"
        end
      end
    end

  end
end