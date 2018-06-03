require_relative "version" # Version reopens this class.

# Jylis database adapter.
class Jylis
  private_class_method :new

  class << self
    # The current connection.
    attr_accessor :current

    # @see Jylis::Connection#connected?
    def connected?
      current.connected?
    end

    # @see Jylis::Connection#reconnect
    def reconnect
      current.reconnect
    end

    # @see Jylis::Connection#disconnect
    def disconnect
      current.disconnect
    end

    # @see Jylis::Connection#query
    def query
      current.query
    end
  end
end
