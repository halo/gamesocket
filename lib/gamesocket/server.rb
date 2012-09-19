require 'satellite/log'
require 'gamesocket/connection'
require 'gamesocket/event'
require 'gamesocket/pool'
require 'gamesocket/remote'


module GameSocket
  class Server < Connection

    def initialize(options={})
      super
      @pool = Pool.new
    end

    def send_event(event)
      unless event.is_a?(Event)
        Log.error "Network stack received invalid event from server: #{event.inspect}"
        return
      end
      unless remote = @pool.find(event.receiver_id)
        Log.debug "Remote #{event.receiver_id.inspect} not found. I have #{@pool.remotes.inspect}"
        return
      end
      payload = Marshal.dump({ sender_id: id, kind: event.kind, data: event.data })
      @socket.send_datagram Datagram.new endpoint: remote.endpoint, port: remote.port, payload: payload
    end

    def broadcast(event)
      unless event.is_a?(Event)
        Log.error "Network stack received invalid broadcast event from server: #{event.inspect}"
        return
      end
      remotes.values.each do |remote|
        customized_event = Event.new receiver_id: remote.id, kind: event.kind, data: event.data
        send_event customized_event
      end
    end

    def receive_events
      receive_remotes_and_payloads do |remote, payload|
        @pool << remote
        yield Event.new sender_id: remote.id, kind: payload[:kind], data: payload[:data]
      end
    end

    def remotes
      @pool.remotes
    end

  end
end
