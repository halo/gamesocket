# -*- encoding: utf-8 -*-
# See https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/hash/keys.rb

class Hash

  # Destructively convert all keys using the block operations.
  # Same as transform_keys but modifies +self+.
  def transform_keys!
    keys.each do |key|
      self[yield(key)] = delete(key)
    end
    self
  end

  # Destructively convert all keys to strings. Same as
  # +stringify_keys+, but modifies +self+.
  def stringify_keys!
    transform_keys!{ |key| key.to_s }
  end

  # Destructively convert all keys to symbols, as long as they respond
  # to +to_sym+. Same as +symbolize_keys+, but modifies +self+.
  def symbolize_keys!
    transform_keys!{ |key| key.to_sym rescue key }
  end
  alias_method :to_options!, :symbolize_keys!

end