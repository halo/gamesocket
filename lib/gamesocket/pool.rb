require 'gamesocket/log'

module GameSocket
  class Pool

    def initialize(options={})
      #@limit = options[:limit] || 256
      @remotes = {}
    end

    def <<(new_remote)
      unless new_remote.valid?
        Log.debug "Refusing to register invalid remote #{new_remote.inspect}."
        return
      end
      if existing_remote = @remotes[new_remote.id]
        Log.debug "#{new_remote.id} already registerd."
        # remote.touch
      else
        Log.debug "Registering Remote #{new_remote.id} (#{new_remote.endpoint}:#{new_remote.port}) in network pool..."
        @remotes[new_remote.id] = new_remote
        # remote.touch
      end
      true
    end

    def find(id)
      @remotes[id]
    end

    def remotes
      @remotes
    end

  end
end