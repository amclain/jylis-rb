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

    # @return [Boolean] true if a connection to the current server is established
    # @see Jylis::Connection#connected?
    def connected?
      current.connected?
    end

    # Reconnect to the current server.
    # @see Jylis::Connection#reconnect
    def reconnect
      current.reconnect
    end

    # Disconnect from the current server.
    # @see Jylis::Connection#disconnect
    def disconnect
      current.disconnect
    end

    # Make a query to the database.
    #
    # @param args data type function args. Can be an args list or array.
    #
    # @return [Array] query response
    #
    # @see Jylis::Connection#query
    # @see https://jemc.github.io/jylis/docs/types/
    def query(*args)
      current.query(*args)
    end

    # @!group Data Types

    # TREG functions
    #
    # @return [Jylis::DataType::TREG]
    #
    # @see Jylis::Connection#treg
    def treg
      current.treg
    end

    # TLOG functions
    #
    # @return [Jylis::DataType::TLOG]
    #
    # @see Jylis::Connection#tlog
    def tlog
      current.tlog
    end

    # GCOUNT functions
    #
    # @return [Jylis::DataType::GCOUNT]
    #
    # @see Jylis::Connection#gcount
    def gcount
      current.gcount
    end

    # PNCOUNT functions
    #
    # @return [Jylis::DataType::PNCOUNT]
    #
    # @see Jylis::Connection#pncount
    def pncount
      current.pncount
    end

    # MVREG functions
    #
    # @return [Jylis::DataType::MVREG]
    #
    # @see Jylis::Connection#mvreg
    def mvreg
      current.mvreg
    end

    # UJSON functions
    #
    # @return [Jylis::DataType::UJSON]
    #
    # @see Jylis::Connection#ujson
    def ujson
      current.ujson
    end

    # @!endgroup
  end
end
