require_relative "version" # Version reopens this class.
require_relative "connection"

# Jylis database adapter.
class Jylis
  private_class_method :new

  class << self
    # The current connection.
    attr_accessor :current

    # Connect to a server and store the current connection.
    #
    # @param server_uri [URI, String] uri of the server to connect to
    #
    # @return [Jylis::Connection] connection
    def connect(server_uri)
      disconnect if current && current.connected?

      self.current = Jylis::Connection.new(server_uri)
    end

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
    def query(*args)
      current.query(*args)
    end

    # @see Jylis::Connection#treg
    def treg
      current.treg
    end

    # @see Jylis::Connection#gcount
    def gcount
      current.gcount
    end
  end
end
