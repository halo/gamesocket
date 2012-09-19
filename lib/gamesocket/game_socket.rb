require 'gamesocket/datagram'
require 'gamesocket/udp_socket'

module GameSocket
  class Socket
    attr_reader :preferred_port, :random_port_tries

    def initialize(options={})
      @preferred_port = options[:preferred_port]
      @random_port_tries = options[:random_port_tries] || 5
      reset!
      start!
    end

    # Public: Resets the listening port.
    def port=(new_port)
      return true if new_port == socket.port
      reset!
      @desired_port = new_port
      start!
      true
    end

    # Public: Sends a single Datagram to the socket.
    #
    # Returns the number of bytes sent or false if nothing was sent.
    # Raises... all sorts of things.
    def send_datagram(datagram)
      return false unless datagram.is_a?(Datagram)
      return false unless datagram.valid?
      return unless datagram.payload.to_s.present?
      bytes_sent = socket.send datagram.payload.to_s, 0, datagram.endpoint, datagram.port
    rescue Errno::EHOSTUNREACH
      false
    end

    def receive_datagrams
      while datagram = receive_datagram
        yield datagram
      end
    end

    def flush
      socket.flush if socket
    end

    # Internal: Free the socket and reset all settings. Useful for testing.
    def reset!
      @desired_port = preferred_port
      socket.close if socket
      @socket = nil
    end

    # Internal: Start listening on a socket. Useful for testing.
    def start!
      ports = ports_to_try
      #Log.debug "Trying ports #{ports.inspect}..."
      until socket.port || !(try_port = ports.shift)
        begin
          #Log.debug "Trying to listen on port #{try_port}..."
          socket.bind port: try_port
          #Log.info "Successfully listening on port #{try_port}..."
        rescue Errno::EADDRINUSE, Errno::EINVAL
          #Log.warn "Port #{try_port} occupied, trying another..."
        end
      end
      #Log.error "Could not find any port to listen on..." unless port
    end

    def port
      socket.port
    end

    private

    # Internal: Getter for the socket
    #
    # Returns: GameSocket::UDPSocket
    def socket
      @socket ||= UDPSocket.new
    end

    def receive_datagrams!
      while datagram = receive_datagram
        yield datagram
      end
    end

    # Internal: Fetches a single packet from the socket.
    #
    # Returns a Datagram or nil if there is nothing (valid) avaliable.
    # Raises... all sorts of things.
    def receive_datagram
      return unless IO.select([socket], nil, nil, 0)
      data = socket.recvfrom_nonblock(65507)
      datagram = Datagram.new payload: data[0], endpoint: data[1][3], port: data[1][1]
      datagram.valid? ? datagram : nil
    end

    # Internal: The priority of ports to try
    def ports_to_try
      result = [@desired_port, preferred_port].uniq
      @random_port_tries.times { |i| result << UDPSocket.random_port }
      result
    end

    # Internal: Returns the official Satellite default game port.
    def preferred_port
      @preferred_port
    end


#      def punch(local_port, remote)
#        puncher = UDPSocket.new
#        puncher.bind nil, local_port
#        puncher.send '', 0, remote.endpoint, remote.port
#        puncher.close
#      end

  end
end