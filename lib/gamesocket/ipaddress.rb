require 'ipaddr'
require 'timeout'

module GameSocket
  class IPAddress

    def self.valid?(address)
      Timeout::timeout(0.1) do
        IPAddr.new(address.to_s.strip)
        return true
      end
      rescue ArgumentError, Timeout::Error
      false
    end

  end
end