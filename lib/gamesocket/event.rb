require 'satellite/extensions/core/object/blank'


module GameSocket
  class Event

    # The unique ID of the sender or receiver
    attr_reader :receiver_id, :sender_id

    # An arbitrary payload
    attr_reader :data

    def initialize(options={})
      @receiver_id = options[:receiver_id].presence.to_s.strip
      @sender_id = options[:sender_id].presence.to_s.strip
      @kind = options[:kind]
      @data = options[:data]
    end

    def broadcast?
      receiver_id.blank?
    end

    # The "name" of this Event
    def kind
      @kind.present? ? @kind.to_s.to_sym : :undefined
    end

    def inspect
      result = %w{ #<Event }
      result << "kind=#{kind.inspect}"
      result << "receiver_id=#{receiver_id.inspect}" if receiver_id.present?
      result << "sender_id=#{sender_id.inspect}" if sender_id.present?
      result << "data=#{data.inspect}"
      result << '>'
      result.compact.join(' ')
    end

  end
end