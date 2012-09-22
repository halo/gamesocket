$: << File.expand_path('../lib', File.dirname(__FILE__))

module GameSocket
  module Test
    extend self

    def server_port
      fetch_or_assign('SERVER_PORT', 33030)
    end

    def client_port
      fetch_or_assign('CLIENT_PORT', 33031)
    end

    def client2_port
      fetch_or_assign('CLIENT2_PORT', 33032)
    end

    private

    def fetch_or_assign(name, new_port)
      current = fetch(name)
      if valid?(current)
        current
      else
        assign(name, new_port)
      end
    end

    def fetch(name)
      ENV[prefix + name].to_i
    end

    def assign(name, new_port)
      ENV[prefix + name] = new_port.to_s
    end

    def prefix
      'GAMESOCKET_TEST_'
    end

    def valid?(port)
      (1024..65535).member?(port.to_i)
    end

  end
end